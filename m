Return-Path: <linux-kernel-owner+w=401wt.eu-S933392AbXJPHq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933392AbXJPHq6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 03:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764686AbXJPHqs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 03:46:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48734 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762055AbXJPHqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 03:46:48 -0400
Subject: Re: [git pull] lockdep for v2.6.24
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
References: <1192469455.27435.87.camel@twins>
	 <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 09:46:44 +0200
Message-Id: <1192520804.27435.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 18:14 -0700, Linus Torvalds wrote:
> 
> On Mon, 15 Oct 2007, Peter Zijlstra wrote:
> > 
> > please pull the lockdep tree from:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-lockdep
> 
> Hmm. I'm now getting
> 
> 	WARNING: at kernel/lockdep.c:700 look_up_lock_class()
> 	
> 	Call Trace:
> 	 [<ffffffff8105562a>] __lock_acquire+0x15f/0xc92
> 	 [<ffffffff810a5804>] do_lookup+0x83/0x1b0
> 	 [<ffffffff8105654a>] lock_acquire+0x5a/0x73
> 	 [<ffffffff810a5804>] do_lookup+0x83/0x1b0
> 	 [<ffffffff81052b59>] debug_mutex_lock_common+0x16/0x23
> 	 [<ffffffff81347d26>] mutex_lock_nested+0x10c/0x2b0
> 	 [<ffffffff810a5804>] do_lookup+0x83/0x1b0
> 	 [<ffffffff810a7b89>] __link_path_walk+0x924/0xde9
> 	 [<ffffffff810a80a6>] link_path_walk+0x58/0xe0
> 	 [<ffffffff81348ef6>] _spin_unlock+0x17/0x20
> 	 [<ffffffff8109cc31>] get_unused_fd_flags+0x115/0x126
> 	 [<ffffffff810a8432>] do_path_lookup+0x1ae/0x229
> 	 [<ffffffff810a8e3d>] __path_lookup_intent_open+0x56/0x96
> 	 [<ffffffff810a8fe0>] open_namei+0x7d/0x66c
> 	 [<ffffffff8109ce9f>] do_filp_open+0x1c/0x38
> 	 [<ffffffff81348ef6>] _spin_unlock+0x17/0x20
> 	 [<ffffffff8109cc31>] get_unused_fd_flags+0x115/0x126
> 	 [<ffffffff8109cf01>] do_sys_open+0x46/0xc3
> 	 [<ffffffff8100bc3e>] system_call+0x7e/0x83
> 
> which seems to be new..

Yeah, Ingo just told me about that too :-(

Seems I dropped a patch in my test runs.. Anyway, pushed a fix into the
above tree.



