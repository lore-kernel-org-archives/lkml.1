Return-Path: <linux-kernel-owner+w=401wt.eu-S1754680Ab0AZRda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab0AZRda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 12:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0AZRd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 12:33:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53296 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab0AZRd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 12:33:28 -0500
To: tromey@redhat.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
From: Andi Kleen <andi@firstfloor.org>
References: <20100121013822.28781960.sfr@canb.auug.org.au>
	<20100122005147.GD22003@redhat.com>
	<20100121170541.7425ff10.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1001211724500.13231@localhost.localdomain>
	<20100122182827.GA13185@redhat.com>
	<20100122200129.GG22003@redhat.com>
	<alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
	<20100122221348.GA4263@redhat.com>
	<alpine.LFD.2.00.1001221604190.13231@localhost.localdomain>
	<alpine.LFD.2.00.1001221614520.13231@localhost.localdomain>
	<f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
	<alpine.LFD.2.00.1001232051510.3574@localhost.localdomain>
	<m33a1tnbd9.fsf@fleche.redhat.com>
Date: Tue, 26 Jan 2010 18:33:26 +0100
In-Reply-To: <m33a1tnbd9.fsf@fleche.redhat.com> (Tom Tromey's message of "Mon, 25 Jan 2010 14:05:54 -0700")
Message-ID: <877hr4g49l.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tom Tromey <tromey@redhat.com> writes:

> * Use an fd, not SIGCHLD+wait, to report inferior state changes to gdb.
>   Internally we're already using a self-pipe to integrate this into
>   gdb's main loop.  Relatedly, don't mess with the inferior's parentage.

How would having a kernel based solution be better over your
user space simulation?

BTW there's the new signalfd() system call that might do it
(haven't checked if it works for SIGCHLD)

> * Support "displaced stepping" in the kernel; I think this would improve
>   performance when debugging in non-stop mode.

Not sure what "displaced stepping" is exactly, but it 
sounds like the branch tracing extensions that got added a 
few releases ago? On modern Intel chips they give you a branch
buffer in memory.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
