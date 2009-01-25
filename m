Return-Path: <linux-kernel-owner+w=401wt.eu-S1756976AbZAYEDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbZAYEDL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 23:03:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755671AbZAYECz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 23:02:55 -0500
Received: from thunk.org ([69.25.196.29]:33384 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625AbZAYECy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 23:02:54 -0500
Date: Sat, 24 Jan 2009 23:02:46 -0500
From: Theodore Tso <tytso@mit.edu>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: Jon Masters <jcm@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Lee Revell <rlrevell@joe-job.com>, linux-rt-users@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RT] [RFC] simple SMI detector
Message-ID: <20090125040246.GE9216@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Sven-Thorsten Dietrich <sdietrich@novell.com>,
	Jon Masters <jcm@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
	Lee Revell <rlrevell@joe-job.com>, linux-rt-users@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>, williams <williams@redhat.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org> <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com> <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain> <1232845026.3990.71.camel@perihelion.bos.jonmasters.org> <1232849565.29318.112.camel@sven.thebigcorporation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232849565.29318.112.camel@sven.thebigcorporation.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2009 at 01:12:45PM +1100, Sven-Thorsten Dietrich wrote:
> Latency-friendly SMI implementations may be found in some systems, and
> not so much in others.
> 
> It should be up to the promotional divisions of the particular hardware
> suppliers to assess the market pressure, and to report the performance
> advantages of their specific systems.

They definitely exist; I spent quite a bit of time working with IBM
hardware engineers on what we called "SMI remediation".  In some cases
it was necessary to have some custom kernel and/or user space code to
run (at background priority) maintenance work such as predictive
failure calculations that really didn't need to be done at SMI
stop-the-OS-on-all-cpus priority, but which hardware manufacturers
would do at the SMI level to avoid needing to create
motherboard-specific device drivers and/or daemons for each OS that
they might want to support.

> I envision documentation of these specs, in a similar fashion to the
> manner in which CPU clock-cycles are documented for specific instruction
> executions - for those systems eligible (certified?) for low-latency
> operation.

I'm not sure exactly how one would do this certification, but I agree
that some kind of "real-time ready" logo/certification program would
make a huge amount of sense, with some standardized metrics of maximum
time spent in an SMI routine, and under what circumstances (in some
cases it occurs every 30-60 minutes; on other cases, only when the CPU
is about to melt itself into slag, or when there are ECC errors, etc.)
There is a huge difference between a system which stops the OS on all
CPU's dead in its tracks for milliseconds once every 45 minutes,
versus one which only triggers an SMI in extreme situations when the
hardware is about to destroy itself.

I will also note that for some applications (i.e., military hardware
running under battle conditions), where it might be that running the
hardware beyond its thermal limits might actually be *desirable*.
After all, an extra 15 minutes of running beyond thermal limits that
eventually causes the CPU to get flakey might be worth it if the
alternative is the ship getting sunk because the BIOS decided that
shutting down the CPU to save it from thermal damage was more
important than say, running the anti-aircraft guns....

							- Ted
