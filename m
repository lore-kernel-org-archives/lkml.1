Return-Path: <linux-kernel-owner+w=401wt.eu-S1760671AbXJPBPZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760671AbXJPBPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 21:15:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbXJPBPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 21:15:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44953 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbXJPBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 21:15:11 -0400
Date: Mon, 15 Oct 2007 18:14:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] lockdep for v2.6.24
In-Reply-To: <1192469455.27435.87.camel@twins>
Message-ID: <alpine.LFD.0.999.0710151813390.6887@woody.linux-foundation.org>
References: <1192469455.27435.87.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 15 Oct 2007, Peter Zijlstra wrote:
> 
> please pull the lockdep tree from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-lockdep.git v2.6.24-lockdep

Hmm. I'm now getting

	WARNING: at kernel/lockdep.c:700 look_up_lock_class()
	
	Call Trace:
	 [<ffffffff8105562a>] __lock_acquire+0x15f/0xc92
	 [<ffffffff810a5804>] do_lookup+0x83/0x1b0
	 [<ffffffff8105654a>] lock_acquire+0x5a/0x73
	 [<ffffffff810a5804>] do_lookup+0x83/0x1b0
	 [<ffffffff81052b59>] debug_mutex_lock_common+0x16/0x23
	 [<ffffffff81347d26>] mutex_lock_nested+0x10c/0x2b0
	 [<ffffffff810a5804>] do_lookup+0x83/0x1b0
	 [<ffffffff810a7b89>] __link_path_walk+0x924/0xde9
	 [<ffffffff810a80a6>] link_path_walk+0x58/0xe0
	 [<ffffffff81348ef6>] _spin_unlock+0x17/0x20
	 [<ffffffff8109cc31>] get_unused_fd_flags+0x115/0x126
	 [<ffffffff810a8432>] do_path_lookup+0x1ae/0x229
	 [<ffffffff810a8e3d>] __path_lookup_intent_open+0x56/0x96
	 [<ffffffff810a8fe0>] open_namei+0x7d/0x66c
	 [<ffffffff8109ce9f>] do_filp_open+0x1c/0x38
	 [<ffffffff81348ef6>] _spin_unlock+0x17/0x20
	 [<ffffffff8109cc31>] get_unused_fd_flags+0x115/0x126
	 [<ffffffff8109cf01>] do_sys_open+0x46/0xc3
	 [<ffffffff8100bc3e>] system_call+0x7e/0x83

which seems to be new..

		Linus
