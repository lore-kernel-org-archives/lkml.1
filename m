Return-Path: <linux-kernel-owner+w=401wt.eu-S1757361AbYFZIT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361AbYFZIT4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYFZISv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:18:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2576 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755624AbYFZISp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:18:45 -0400
Date: Tue, 24 Jun 2008 11:15:16 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Message-ID: <20080624091516.GA5642@ucw.cz>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201353.59083.rjw@sisk.pl> <20080620115714.GC8637@srcf.ucam.org> <200806201422.12659.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806201422.12659.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > What does ACPI claim the trip points are set to in this case? On the 
> > 6125, if IRQ 2 is enabled in the APIC then the DSDT sets all the thermal 
> > trip points to 16 degrees C. I suspect this means that enabling IRQ 2 is 
> > the wrong thing to do on this chipset.
> 
> Ah, indeed, thanks for the hint.  This is the output of
> 
> $ cat /proc/acpi/thermal_zone/TZ*/trip_points
> 
> in the failing case:
> 
> critical (S5):           105 C
> passive:                 16 C: tc1=1 tc2=2 tsp=100 devices=C000 C001 
> active[0]:               16 C: devices=C34F 
> active[1]:               16 C: devices=C350 
> active[2]:               16 C: devices=C351 
> active[3]:               16 C: devices=C352 
> critical (S5):           100 C
> passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> critical (S5):           100 C
> passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 

Can we call the ACPI BIOS to be terminally broken at this point?

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
