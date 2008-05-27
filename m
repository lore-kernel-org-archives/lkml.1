Return-Path: <linux-kernel-owner+w=401wt.eu-S1758587AbYE0Qny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587AbYE0Qny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 12:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757487AbYE0Qnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 12:43:46 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:57874 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757440AbYE0Qnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 12:43:46 -0400
Date: Tue, 27 May 2008 20:45:19 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: 2.6.26-rc4: RIP find_pid_ns+0x6b/0xa0
Message-ID: <20080527164519.GA826@tv-sign.ru>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org> <20080527052318.GA28301@martell.zuzino.mipt.ru> <20080527090605.GA146@tv-sign.ru> <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805270746090.2958@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27, Linus Torvalds wrote:
> 
> On Tue, 27 May 2008, Oleg Nesterov wrote:
> 
> > In theory find_pid() is not safe without rcu_read_lock() if CONFIG_PREEMPT_RCU.
> > But we have a lot of "read_lock(tasklist_lock) + find_pid()", this was legal
> > and documented. It was actually broken, but happened to work because read_lock()
> > implied rcu_read_lock().
> > 
> > Could you look at
> > 
> > 	[PATCH] fix tasklist + find_pid() with CONFIG_PREEMPT_RCU
> > 	http://marc.info/?t=120162615300012
> > 
> > ?
> > 
> > I am not sure this is the actual reason though, the race is very unlikely.
> 
> That is a *very* unlikely race, especially as that bad_fork_free_pid case 
> would only happen if pid_ns_prepare_proc() fails.

To be precise, this case also happens when fork() fails due to signal_pending().

But I agree, this race is pretty much theoretical.

Oleg.

