Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136Ab0AWLAX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab0AWLAX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 06:00:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384Ab0AWLAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 06:00:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53292 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941Ab0AWLAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 06:00:20 -0500
Date: Sat, 23 Jan 2010 11:01:21 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       "Fr??d??ric Weisbecker" <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100123110121.1ce89bb9@lxorguk.ukuu.org.uk>
In-Reply-To: <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com>
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
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The killer app for this will be the ability to delete thousands of
> lines of code from GDB, strace, and all the various other tools that
> have to painfully work around the major interface gotchas of ptrace(),
> while at the same time making their handling of complex processes much
> more robust.

Years ago (and it really must be years ago because this was about the
time I started hacking on Linux stuff !) there was a proposal to extract
and sanitize the arch specific stuff in binutils and in gdb etc into
sensible libraries that could be used by other apps.

What I don't understand is why that doesn't solve 99% of your problem.
ptrace is not perfect but most of the real ptrace limitations actually
come about because either the CPU can't do something or because the
supporting logic would be too expensive - things like having extra
private debugger pages.

Yes ptrace needs a lot of icky support code, but it's already been
written...

Alan
