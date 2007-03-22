Return-Path: <linux-kernel-owner+w=401wt.eu-S965837AbXCVHXZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965837AbXCVHXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:23:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965841AbXCVHXY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:23:24 -0400
Received: from amsfep16-int.chello.nl ([62.179.120.11]:42899 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965837AbXCVHXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:23:23 -0400
Subject: Re: [PATCH] lockdep: debug_show_all_locks &  debug_show_held_locks
	vs. debug_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070322065759.GB1466@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown>
	 <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru>
	 <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru>
	 <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru>
	 <20070321181635.GA570@tv-sign.ru> <20070322061119.GA1466@ff.dom.local>
	 <20070322065759.GB1466@ff.dom.local>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 08:23:20 +0100
Message-Id: <1174548200.16411.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 07:57 +0100, Jarek Poplawski wrote:
> And here is some addition.
> 
> [PATCH] lockdep: debug_show_all_locks &  debug_show_held_locks vs. debug_locks
>  
> lockdep's data shouldn't be used when debug_locks == 0
> because it's not updated after this, so it's more misleading
> than helpful.
> 
> PS: probably lockdep's current-> fields should be reset after
> it turns debug_locks off: so, after printing a bug report, but
> before return from exported functions, but there are really
> a lot of these possibilities (e.g. after DEBUG_LOCKS_WARN_ON),
> so, something could be missed. (Of course direct use of this
> fields isn't recommended either.)
> 
> Reported-by: Folkert van Heusden <folkert@vanheusden.com>
> Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> 
> diff -Nurp 2.6.21-rc4-git4-/kernel/lockdep.c 2.6.21-rc4-git4/kernel/lockdep.c
> --- 2.6.21-rc4-git4-/kernel/lockdep.c	2007-03-21 22:46:26.000000000 +0100
> +++ 2.6.21-rc4-git4/kernel/lockdep.c	2007-03-21 23:05:17.000000000 +0100
> @@ -2742,6 +2742,10 @@ void debug_show_all_locks(void)
>  	int count = 10;
>  	int unlock = 1;
>  
> +	if (unlikely(!debug_locks)) {
> +		printk("INFO: lockdep is turned off.\n");
> +		return;
> +	}
>  	printk("\nShowing all locks held in the system:\n");
>  
>  	/*
> @@ -2785,6 +2789,10 @@ EXPORT_SYMBOL_GPL(debug_show_all_locks);
>  
>  void debug_show_held_locks(struct task_struct *task)
>  {
> +	if (unlikely(!debug_locks)) {
> +		printk("INFO: lockdep is turned off.\n");
> +		return;
> +	}
>  	lockdep_print_held_locks(task);
>  }
>  

