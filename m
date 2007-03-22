Return-Path: <linux-kernel-owner+w=401wt.eu-S1752439AbXCVG2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbXCVG2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 02:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXCVG2r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 02:28:47 -0400
Received: from smtp.osdl.org ([65.172.181.24]:41298 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185AbXCVG2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 02:28:46 -0400
Date: Wed, 21 Mar 2007 22:28:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Neil Brown <neilb@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Folkert van Heusden <folkert@vanheusden.com>,
       linux-kernel@vger.kernel.org, "J\. Bruce Fields" <bfields@fieldses.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] lockdep: lockdep_depth vs. debug_locks Re: [2.6.20]
 BUG: workqueue leaked lock
Message-Id: <20070321222802.0e09f0c2.akpm@linux-foundation.org>
In-Reply-To: <20070322061119.GA1466@ff.dom.local>
References: <17918.11420.155569.991473@notabene.brown>
	<20070320093753.GA1751@ff.dom.local>
	<20070320160759.GA107@tv-sign.ru>
	<20070321080510.GA1939@ff.dom.local>
	<20070321144620.GC78@tv-sign.ru>
	<20070321151651.GA4547@ff.dom.local>
	<20070321152935.GA215@tv-sign.ru>
	<20070321181635.GA570@tv-sign.ru>
	<20070322061119.GA1466@ff.dom.local>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007 07:11:19 +0100 Jarek Poplawski <jarkao2@o2.pl> wrote:

> 
> Here is some joke:
> 
> [PATCH] lockdep: lockdep_depth vs. debug_locks
> 
> lockdep really shouldn't be used when debug_locks == 0!
> 

This isn't a very good changelog.

> 
> Reported-by: Folkert van Heusden <folkert@vanheusden.com>
> Inspired-by: Oleg Nesterov <oleg@tv-sign.ru>
> Signed-off-by: Jarek Poplawski <jarkao2@o2.pl>
> 
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

What problem does this solve, and how does it solve it?

I assume that some codepath is incrementing ->lockdep_depth even when
debug_locks==0.  Isn't that wrong of it?
