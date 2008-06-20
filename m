Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYFTMUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYFTMUw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 08:20:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752834AbYFTMUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 08:20:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55115 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbYFTMUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 08:20:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: linux-next: Tree for June 13: IO APIC breakage on HP nx6325
Date: Fri, 20 Jun 2008 14:22:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <200806201353.59083.rjw@sisk.pl> <20080620115714.GC8637@srcf.ucam.org>
In-Reply-To: <20080620115714.GC8637@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806201422.12659.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 of June 2008, Matthew Garrett wrote:
> On Fri, Jun 20, 2008 at 01:53:58PM +0200, Rafael J. Wysocki wrote:
> 
> > What exactly I observe is that in this case:
> > 1) The cooling fan is 100% on, as though the box were overheating, which seems
> >    to indicate some serious confusion of the platform (the mechanism turning
> >    the fan 100% on is supposed to be transparent to software).
> > 2) Everything seems to slow down substantially, at least as soon as X is
> >    started.
> 
> What does ACPI claim the trip points are set to in this case? On the 
> 6125, if IRQ 2 is enabled in the APIC then the DSDT sets all the thermal 
> trip points to 16 degrees C. I suspect this means that enabling IRQ 2 is 
> the wrong thing to do on this chipset.

Ah, indeed, thanks for the hint.  This is the output of

$ cat /proc/acpi/thermal_zone/TZ*/trip_points

in the failing case:

critical (S5):           105 C
passive:                 16 C: tc1=1 tc2=2 tsp=100 devices=C000 C001 
active[0]:               16 C: devices=C34F 
active[1]:               16 C: devices=C350 
active[2]:               16 C: devices=C351 
active[3]:               16 C: devices=C352 
critical (S5):           100 C
passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 
critical (S5):           100 C
passive:                 16 C: tc1=1 tc2=2 tsp=300 devices=C000 C001 

(also available at: http://www.sisk.pl/kernel/debug/20080620/trip-points.txt).

So, the observed slowdown may be a result of throttling.

Thanks,
Rafael
