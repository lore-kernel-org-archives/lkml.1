Return-Path: <linux-kernel-owner+w=401wt.eu-S965828AbXCVHWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965828AbXCVHWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 03:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965837AbXCVHWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 03:22:41 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:7035 "EHLO
	amsfep18-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S965828AbXCVHWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 03:22:40 -0400
Subject: Re: [PATCH] lockdep: lockdep_depth vs. debug_locks Re: [2.6.20]
	BUG: workqueue leaked lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070322061119.GA1466@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown>
	 <20070320093753.GA1751@ff.dom.local> <20070320160759.GA107@tv-sign.ru>
	 <20070321080510.GA1939@ff.dom.local> <20070321144620.GC78@tv-sign.ru>
	 <20070321151651.GA4547@ff.dom.local> <20070321152935.GA215@tv-sign.ru>
	 <20070321181635.GA570@tv-sign.ru>  <20070322061119.GA1466@ff.dom.local>
Content-Type: text/plain
Date: Thu, 22 Mar 2007 08:22:37 +0100
Message-Id: <1174548157.16411.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 07:11 +0100, Jarek Poplawski wrote:
> Here is some joke:
> 
> [PATCH] lockdep: lockdep_depth vs. debug_locks
> 
> lockdep really shouldn't be used when debug_locks == 0!

This happens then lockdep reports a fatal error, at which point
it will stop tracking locks and leave whatever state was there.

> Reported-by: Folkert van Heusden <folkert@vanheusden.com>
> Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>

This looks sane, thanks for figuring this out.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> 
> diff -Nurp 2.6.21-rc4-git4-/include/linux/lockdep.h 2.6.21-rc4-git4/include/linux/lockdep.h
> --- 2.6.21-rc4-git4-/include/linux/lockdep.h	2007-03-20 20:24:17.000000000 +0100
> +++ 2.6.21-rc4-git4/include/linux/lockdep.h	2007-03-21 22:32:41.000000000 +0100
> @@ -245,7 +245,7 @@ extern void lock_release(struct lockdep_
>  
>  # define INIT_LOCKDEP				.lockdep_recursion = 0,
>  
> -#define lockdep_depth(tsk)	((tsk)->lockdep_depth)
> +#define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
>  
>  #else /* !LOCKDEP */
>  

