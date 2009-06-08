Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbZFHGl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbZFHGl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbZFHGlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:41:49 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:57017 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450AbZFHGls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:41:48 -0400
Date: Mon, 8 Jun 2009 12:11:49 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH] kmemcheck: move hook before preempt_conditional_sti()
Message-ID: <20090608064148.GA516@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1244392012-638-1-git-send-email-vegard.nossum@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244392012-638-1-git-send-email-vegard.nossum@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 06:26:52PM +0200, Vegard Nossum wrote:
> There are actually two problems here:
> 
> 1. We absolutely cannot enable IRQs in case the fault was caused by
>    kmemcheck.
> 
> 2. We cannot enable preemption and then return from the debug handler
>    without disabling preemption afterwards.
> 
> The problem seems to be a merge fallout between three commits:
> 
> commit 3d2a71a596bd9c761c8487a2178e95f8a61da083
> Author: Alexander van Heukelum <heukelum@fastmail.fm>
> Date:   Tue Sep 30 18:41:37 2008 +0200
> 
>     x86, traps: converge do_debug handlers
> 
> commit 08d68323d1f0c34452e614263b212ca556dae47f
> Author: K.Prasad <prasad@linux.vnet.ibm.com>
> Date:   Mon Jun 1 23:44:08 2009 +0530
> 
>     hw-breakpoints: modifying generic debug exception to use thread-specific deb
> 
> commit 787ecfaa503dc63ff1831ddc74b15dad49bace1d
> Author: Vegard Nossum <vegard.nossum@gmail.com>
> Date:   Fri Apr 4 00:53:23 2008 +0200
> 
>     x86: add hooks for kmemcheck
> 
> I encourage the kprobe developers to check whether their code is correct
> as it stands in current tip/master. Also, comments on this particular
> change is welcome.

I see no problem with this change wrt kprobes, since the changes happen
after the notify_die, by which time, kprobes would've returned
NOTIFY_DONE since the per-cpu current_kprobe == NULL.

Ananth
