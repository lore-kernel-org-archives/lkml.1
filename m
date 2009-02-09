Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbZBIMET@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbZBIMET (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 07:04:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbZBIMEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 07:04:11 -0500
Received: from www.tglx.de ([62.245.132.106]:51798 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbZBIMEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 07:04:10 -0500
Date: Mon, 9 Feb 2009 13:03:53 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Paul Collins <paul@burly.ondioline.org>, Ingo Molnar <mingo@elte.hu>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: Badness at kernel/time/timekeeping.c:98 in pmud
 (timekeeping_suspended)
In-Reply-To: <200902081439.31548.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0902091302310.415@localhost.localdomain>
References: <87prihcepl.fsf@burly.wgtn.ondioline.org> <87k58nda87.fsf@burly.wgtn.ondioline.org> <874oz5pmvd.fsf@burly.wgtn.ondioline.org> <200902081439.31548.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Feb 2009, Rafael J. Wysocki wrote:

> On Sunday 08 February 2009, Paul Collins wrote:
> > Paul Collins <paul@burly.ondioline.org> writes:
> > 
> > > "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> > >
> > >> On Wednesday 21 January 2009, Paul Collins wrote:
> > >>> Got a couple of these on a PowerBook running 2.6.29-rc2 either during
> > >>> suspend or resume -- it's hard to tell.  (The suspend message is
> > >>> timestamped in syslog with the time I resumed, so I guess it was
> > >>> buffered along with the subsequent "Badness" messages.)
> > >>
> > >> Please check if the patch from http://lkml.org/lkml/2009/1/13/144 fixes the
> > >> problem for you.
> > >
> > > It does not fix the problem.
> > 
> > I'm also getting this warning since 2.6.28.1, which incorporated commit
> > 1c5745aa380efb6417b5681104b007c8612fb496 ("sched_clock: prevent
> > scd->clock from moving backwards, take #2") as commit
> > e268dcdd404f4558cdd24c8ecede3e064df8fa33, this being the patch that
> > introduced the WARN_ON(timekeeping_suspended) check.
> 
> Hm, I thought the timekeeping suspend problem was fixed in this commit.  Ingo?

The commit fixed the problem with sched_clock, but it does not fix
problems where other parts of the kernel call timekeeping functions
_AFTER_ timekeeping has been suspended.

Thanks,

	tglx

