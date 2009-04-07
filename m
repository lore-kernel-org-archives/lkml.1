Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZDGGyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZDGGyJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 02:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZDGGxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 02:53:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49221 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZDGGxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 02:53:53 -0400
Date: Tue, 7 Apr 2009 08:53:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avan Anishchuk <matimatik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: Re: [PATCH] ramfs: fix double freeing s_fs_info on failed mount
Message-ID: <20090407065308.GA19470@elte.hu>
References: <20090405193944.GA12691@elte.hu> <alpine.LFD.2.00.0904061842490.4010@localhost.localdomain> <alpine.LFD.2.00.0904062045530.4010@localhost.localdomain> <alpine.LFD.2.00.0904062108550.4010@localhost.localdomain> <alpine.LFD.2.00.0904062142110.4010@localhost.localdomain> <20090407052801.GA4235@elte.hu> <20090407055502.GA22881@localhost> <20090407060309.GA21788@elte.hu> <20090407061650.GA31745@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090407061650.GA31745@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Wu Fengguang <fengguang.wu@intel.com> wrote:

> From: Ingo Molnar <mingo@elte.hu>
> 
> If ramfs mount fails, s_fs_info will be freed twice in 
> ramfs_fill_super() and ramfs_kill_sb(), leading to kernel oops.
> 
> Consolidate and beautify the code. Make sure s_fs_info and s_root 
> are in known good states.
> 
> Acked-by: Wu Fengguang <fengguang.wu@intel.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>

Nit: the commit is missing a Reported-by :)

Linus might not insist on seeing his name mentioned yet another time 
in a commit, but it's generally good practice to always add bug 
report info and names.

Note that in this case the really hard work was there: Linus had to 
spend at least 2 hours on tracking down and bisecting this bug. (and 
Linus probably did this super-fast compared to the average tester - 
most other bug reporters spend a day or more on bisection, limited 
by lack of practice and by the slowness of kernel builds on ordinary 
hardware.)

So the real human effort was spent there, not in my 5 minutes on 
fixing the bug that Linus served on a plate - while the commit only 
credits me. That's not fair :)

See the tip:out-of-tree local commit i made and sent out.

	Ingo
