Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZLFIkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZLFIkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 03:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755756AbZLFIkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 03:40:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43701 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbZLFIkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 03:40:00 -0500
Date: Sun, 6 Dec 2009 09:39:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [GIT PULL] PM updates for 2.6.33
Message-ID: <20091206083941.GA2881@elte.hu>
References: <200912052216.19540.rjw@sisk.pl>
 <200912060055.36130.rjw@sisk.pl>
 <20091205164541.5e0f209a@infradead.org>
 <200912060226.06217.rjw@sisk.pl>
 <20091205175852.2500cdad@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091205175852.2500cdad@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> On Sun, 6 Dec 2009 02:26:06 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday 06 December 2009, Arjan van de Ven wrote:
> > > On Sun, 6 Dec 2009 00:55:36 +0100
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > 
> > > > Disk spinup/spindown takes time, but also some ACPI devices resume
> > > > slowly, serio devices do that too and there are surprisingly many
> > > > drivers that wait (using msleep() during suspend and resume).
> > > > Apart from this, every PCI device going from D0 to D3 during
> > > > suspend and from D3 to D0 during resume requires us to sleep for
> > > > 10 ms (the sleeping is done by the PCI core, so the drivers don't
> > > > even realize its there).
> > > 
> > > maybe a good step is to make a scripts/bootgraph.pl equivalent for
> > > suspend/resume (or make a debug mode that outputs in a compatible
> > > format so that the script can be used as is.. I don't mind either
> > > way, and consider this my offer to help with such a script as long
> > > as there's sufficient logging in dmesg ;-)
> > 
> > OK, so what kind of logging is needed?
> 
> basically the equivalent of the two initcall_debug paths in
> 
> init/main.c:do_one_initcall()
> 
> which prints a start time and an end time (and a pid) for each init 
> function; if we have the same for suspend calls (and resume)... we can 
> make the tool graph it.
>
> Would be nice to get markers for start and end of the whole suspend 
> sequence as well as for the resume sequence; those make it easier to 
> know when the end is (so that the axis can be drawn etc)
> 
> shouldn't be too hard to implement...

I think an even better option would be to extend 'perf timechart' to be 
suspend/resume aware: add a few tracepoint events and teach 'perf 
timechart' to draw them. (We should be able to do perf timechart record 
across suspend/resume cycles just fine.)

( Doing that would also improve the tracing facilities within 
  suspend/resume quite significantly. It wouldnt just be a 
  single-purpose thing for graphing, but perf trace and perf stat would 
  work equally well. )

Thanks,

	Ingo
