Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYFZIfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYFZIfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbYFZIf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:35:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56971 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752949AbYFZIf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:35:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Thu, 26 Jun 2008 10:37:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201422.12659.rjw@sisk.pl> <20080624091516.GA5642@ucw.cz>
In-Reply-To: <20080624091516.GA5642@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806261037.20108.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 24 of June 2008, Pavel Machek wrote:
> Hi!
> 
> > > What does ACPI claim the trip points are set to in this case? On the 
> > > 6125, if IRQ 2 is enabled in the APIC then the DSDT sets all the thermal 
> > > trip points to 16 degrees C. I suspect this means that enabling IRQ 2 is 
> > > the wrong thing to do on this chipset.
> > 
> > Ah, indeed, thanks for the hint.  This is the output of
> > 
> > $ cat /proc/acpi/thermal_zone/TZ*/trip_points
> > 
> > in the failing case:
> > 
> > critical (S5):           105 C
> > passive:                 16 C: tc1=1 tc2=2 tsp=100 devices=C000 C001 
> > active[0]:               16 C: devices=C34F 
> > active[1]:               16 C: devices=C350 
> > active[2]:               16 C: devices=C351 
> > active[3]:               16 C: devices=C352 
> > critical (S5):           100 C
> > passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> > critical (S5):           100 C
> > passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
> 
> Can we call the ACPI BIOS to be terminally broken at this point?

It is broken, but the configuration worked before the patch.  Consequently,
the patch introduces a regression.

Thanks,
Rafael
