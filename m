Return-Path: <linux-kernel-owner+w=401wt.eu-S1031110AbXDQQCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031110AbXDQQCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 12:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031111AbXDQQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 12:02:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55864 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031110AbXDQQCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 12:02:34 -0400
Date: Tue, 17 Apr 2007 18:01:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?utf-8?B?Uy7Dh2HEn2xhcg==?= Onur <caglar@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>,
       Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Christophe Thommeret <hftom@free.fr>,
       Christoph Pfister <christophpfister@gmail.com>,
       Jurgen Kofler <kaffeine@gmx.net>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
Message-ID: <20070417160142.GA18861@elte.hu>
References: <20070416220715.GA4071@elte.hu> <200704170112.35819.caglar@pardus.org.tr> <20070417085936.GB16645@elte.hu> <200704171745.22544.caglar@pardus.org.tr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200704171745.22544.caglar@pardus.org.tr>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* S.Çağlar Onur <caglar@pardus.org.tr> wrote:

> If you want me to test something else just ask please :)

yes, it would be nice to do a:

	strace -o kaffine.log -f -tttTTT kaffeine

log. Because in your old log this is visible:

 clone(child_stack=0xb02394a4, 
 flags=CLONE_VM|CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|CLONE_SYSVSEM|CLONE_SETTLS|CLONE_PARENT_SETTID|CLONE_CHILD_CLEARTID, 
 parent_tidptr=0xb0239bd8, {entry_number:6, base_addr:0xb0239b90, 
 limit:1048575, seg_32bit:1, contents:0, read_exec_only:0, 
 limit_in_pages:1, seg_not_present:0, useable:1}, 
 child_tidptr=0xb0239bd8) = 11340
 futex(0x89ac218, FUTEX_WAKE, 1)         = 1

we cloned a task and immediately afterwards we used futex 0x89ac218. 
After that point many things happen, but the lockup itself:

 futex(0x89ac218, FUTEX_WAIT, 2, NULL)   = 0
 futex(0x89ac218, FUTEX_WAIT, 2, NULL)   = 0
 futex(0x89ac218, FUTEX_WAIT, 2, NULL)   = 0

is the same futex. Probably related to the same child thread? It would 
be nice to also get a gdb backtrace:

	gdb kaffine
	<reproduce the hang>
	Ctrl-C
	bt

this should give you a gdb backtrace of that kaffeine hang. Thanks,

	Ingo
