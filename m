Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbXBERIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbXBERIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXBERIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:08:17 -0500
Received: from hqemgate02.nvidia.com ([216.228.112.143]:12717 "EHLO
	HQEMGATE02.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652AbXBERIQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:08:16 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5.7226.0
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Nvidia cable detection problems (was [PATCH] amd74xx: don't configure udma mode higher than BIOS did)
Date: Mon, 5 Feb 2007 09:08:03 -0800
Message-ID: <DBFABB80F7FD3143A911F9E6CFD477B01EC0DD7D@hqemmail02.nvidia.com>
In-Reply-To: <58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Nvidia cable detection problems (was [PATCH] amd74xx: don't configure udma mode higher than BIOS did)
thread-index: AcdJN5KKdoHKNDvrROOr6aSVK5e8jQADyy4g
References: <20070205075836.GG1625@htj.dyndns.org> <20070205112410.5a3c3182@localhost.localdomain> <45C72012.7050605@gmail.com> <20070205132247.6f611e3c@localhost.localdomain> <45C73A3E.6080700@gmail.com> <20070205143439.6962c076@localhost.localdomain> <45C7444F.4070500@gmail.com> <58cb370e0702050709w1b7682dr5dff9e7ce69465a@mail.gmail.com>
From: "Allen Martin" <AMartin@nvidia.com>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: <linux-ide@vger.kernel.org>, "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 05 Feb 2007 17:07:25.0223 (UTC) FILETIME=[1B8FCB70:01C74948]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately there's no standard way to do host side cable detect on
nForce systems without going through ACPI.  It's done through a GPIO
pin.  Board vendors are free to reallocate which GPIO pin is used for
this feature.  

One possible solution is to leave the default DMA mode at whatever the
BIOS left it at.  So if it's a UDMA5 drive but the BIOS left it at UDMA2
it was because of cable detect.

The *real* solution is to use the BIOS ACPI _GTM _STM methods for this.
Then you can remove all chipset specific knowledge from the IDE driver.
This is what the MS driver does on Windows, so you know it's received a
lot of testing from NVIDIA and board vendors.

-Allen

> -----Original Message-----
> From: Bartlomiej Zolnierkiewicz [mailto:bzolnier@gmail.com] 
> Sent: Monday, February 05, 2007 7:09 AM
> To: Allen Martin
> Subject: Fwd: Nvidia cable detection problems (was [PATCH] 
> amd74xx: don't configure udma mode higher than BIOS did)
> 
> Hi Allen,
> 
> Would it be possible to get some help on this issue?
> 
> Thanks,
> Bart
> 
> ---------- Forwarded message ----------
> From: Tejun Heo <htejun@gmail.com>
> Date: Feb 5, 2007 3:50 PM
> Subject: Re: Nvidia cable detection problems (was [PATCH] amd74xx:
> don't configure udma mode higher than BIOS did)
> To: Alan <alan@lxorguk.ukuu.org.uk>
> Cc: bzolnier@gmail.com, linux-ide@vger.kernel.org, 
> linux-kernel@vger.kernel.org
> 
> 
> Alan wrote:
> [--snip--]
> >> CK804 IDE, at least mine, reports 80c in a lot of cases where it 
> >> shouldn't.  I dunno the reason but it also makes drives confused 
> >> about cable type.  Maybe it has the wrong capacitor 
> attached or something.
> >> This is A8N-E from ASUS, probably one of the popular ones 
> using nf4.
> >
> > I take it this was how you came to find every cable related 
> bug while 
> > trying to work out what was going on ?
> 
> Yeap, pretty much.  I thought fixing drive side cable 
> detection would fix it, but hell no.
> 
> >> When that happens, libata EH does its job and slows the 
> interface to
> >> udma33 after quite a few error messages.  On IDE, if this happens, 
> >> the drive is put into PIO mode making the machine painful to use.
> >
> > No the IDE layer does DMA changedown fine, well apart from all the 
> > error/timer races in the old IDE code.
> 
> I dunno.  It always ended up in PIO mode in my case.  I can 
> post the log if necessary.
> 
> [--snip--]
> >> I agree with you that this is a hack and ugly as hell.  I 
> don't like 
> >> it either, but it solves an existing problem which could have and 
> >> possibly will hit many users.  So, I think this problem should at 
> >> least be verified.  If it's just my BIOS/motherboard 
> that's crazy, I 
> >> have no problem forgetting about this.
> >
> > It certainly seems to be Nvidia specific, so perhaps Nvidia can 
> > provide more details on the Nforce4 cable detection ? As 
> with a lot of 
> > Nvidia stuff there was much reverse engineering involved in the 
> > original code base.
> 
> Hmmm... Anyone happen to have working nvidia contact?
> 
> > And if its a specific board or couple of boards then we 
> should perhaps 
> > use DMI to match them specifically.
> >
> >> So, anyone with CK804 (a.k.a NF4) up for some testing?
> >
> > If it still goes I've got a rather iffy NF3 but not an NF4 handy.
> 
> Yeah, please.  If I connect a hdd at the end of 40c cable and 
> leaving the middle connector empty, the 80c bit is always one 
> and the drive says it's 80c cable while the BIOS configured 
> mode is correctly udma33.  This is the same for SAMSUNG 
> SP0802N, Maxtor 91301U3 and HITACHI_DK23BA-20.
> 
> --
> tejun
> 
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
