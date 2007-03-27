Return-Path: <linux-kernel-owner+w=401wt.eu-S965489AbXC0Vbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965489AbXC0Vbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 17:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965491AbXC0Vbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 17:31:35 -0400
Received: from hera.kernel.org ([140.211.167.34]:34630 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965489AbXC0Vbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 17:31:33 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] i386: add command line option "local_apic_timer_c2_ok"
Date: Tue, 27 Mar 2007 17:19:25 -0400
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mingming Cao <cmm@us.ibm.com>,
       Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Oliver Pinter <oliver.pntr@gmail.com>,
       Sid Boyce <g3vbv@blueyonder.co.uk>, Nick Piggin <npiggin@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Thomas Renninger <trenn@suse.de>
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070326123141.GA11288@ucw.cz> <1174917142.4182.39.camel@chaos>
In-Reply-To: <1174917142.4182.39.camel@chaos>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703271719.25795.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 March 2007 09:52, Thomas Gleixner wrote:
> On Mon, 2007-03-26 at 12:31 +0000, Pavel Machek wrote:
> > > +	lapic_timer_c2_ok	[IA-32,APIC] trust the local apic timer in
> > > +			C2 power state.
> > > +

> I still twist my brain how to autodetect that in a safe way, which would
> make it really useful for the firmware tester.

I think the only fool-proof way to do this automatically is to
1. do a boot-time calibration vs HPET, RTC, or 8254 to make sure it starts sane.
   ideally, this boot time test would enter the deepest available C-state --
   as that would catch 99% of the failures.
2. do a _continuous_ sanity check against the same time to make sure it never gets off track.
   It has to be continuous because we apparently have no control over
   when the BIOS breaks it on some systems.  However, continuous really
   means "long term" here, because over the uptime of the system we'd
   probably notice the drift between different timers etc, so we'd
   have to reset the sanity check periodically to not get fooled by that.

If this worked, then we could delete the new DMI entry for the nx6325,
as that would get detected and disable the lapic timer use automatically.
We could also delete the check for C2 and the check for C3 to disable
the lapic timer.

-Len
