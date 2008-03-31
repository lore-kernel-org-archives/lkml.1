Return-Path: <linux-kernel-owner+w=401wt.eu-S1758019AbYCaVIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758019AbYCaVIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755313AbYCaVIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:08:23 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:57122 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143AbYCaVIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:08:23 -0400
Date: Tue, 1 Apr 2008 00:07:58 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] do_wait reorganization
Message-ID: <20080331200758.GA115@tv-sign.ru>
References: <20080329033412.120EE26FA1D@magilla.localdomain> <alpine.LFD.1.00.0803290906050.14670@woody.linux-foundation.org> <20080331035701.3926726F8E9@magilla.localdomain> <20080331085110.GA400@tv-sign.ru> <20080331202910.5C4C926F8E9@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080331202910.5C4C926F8E9@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31, Roland McGrath wrote:
>
> I think it should look like this:
> 
>     {
> 	    int ret = eligible_child(type, pid, options, p);
> 	    if (ret <= 0)
> 		    return ret;
> 
> 	    if (p->exit_state == EXIT_DEAD)
> 		    return 0;
> 
> 	    /*
> 	     * We don't reap group leaders with subthreads.
> 	     */
> 	    if (p->exit_state == EXIT_ZOMBIE && !delay_group_leader(p))
> 		    return wait_task_zombie(p, options, infop, stat_addr, ru);
> 
> 	    /*
> 	     * It's stopped or running now, so it might
> 	     * later continue, exit, or stop again.
> 	     */
> 	    *retval = 0;
> 
> 	    if (task_is_stopped_or_traced(p))
> 		    return wait_task_stopped(p, options, infop, stat_addr, ru);
> 
> 	    return wait_task_continued(p, options, infop, stat_addr, ru);
>     }

I think you are right.

(BTW, you moved the "options & WHATEVER" checks into wait_task_xxx(),
 I think this really makes the code more readable and maintainable).

Oleg.

