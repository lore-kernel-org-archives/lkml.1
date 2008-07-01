Return-Path: <linux-kernel-owner+w=401wt.eu-S1759376AbYGAP66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376AbYGAP66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYGAP6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:58:50 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54539 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970AbYGAP6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:58:48 -0400
X-BigFish: VPS-25(z1039oz542N1432R7efV1805Mzzzz15cbj5a6ciz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Date: Tue, 1 Jul 2008 08:58:43 -0700
In-Reply-To: <1214893302.20711.102.camel@pasglop>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 12/60] microblaze_v4: Generic dts file for platforms
Thread-Index: AcjbQz97k2rWIwwhS6euqvMxEdpVPgAT3xWQ
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz> <1214483429-32360-6-git-send-email-monstr@seznam.cz> <1214483429-32360-7-git-send-email-monstr@seznam.cz> <1214483429-32360-8-git-send-email-monstr@seznam.cz> <1214483429-32360-9-git-send-email-monstr@seznam.cz> <1214483429-32360-10-git-send-email-monstr@seznam.cz> <1214483429-32360-11-git-send-email-monstr@seznam.cz> <1214483429-32360-12-git-send-email-monstr@seznam.cz> <1214483429-32360-13-git-send-email-monstr@seznam.cz> <fa686aa40806272249l7eae0c34k43a20ad41672b77a@mail.gmail.com> <1d3f23370806291702g4344a2f9lb62f85cbb475fca4@mail.gmail.com> <20080630033943.332471860046@mail171-va3.bigfish.com> <1214893302.20711.102.camel@pasglop>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <benh@kernel.crashing.org>
CC: "John Williams" <john.williams@petalogix.com>, <grant.likely@secretlab.ca>,
       <linux-arch@vger.kernel.org>, "Michal Simek" <monstr@monstr.eu>,
       <vapier.adi@gmail.com>, <arnd@arndb.de>, <matthew@wil.cx>,
       <microblaze-uclinux@itee.uq.edu.au>, <linux-kernel@vger.kernel.org>,
       <linuxppc-dev@ozlabs.org>, <will.newton@gmail.com>, <hpa@zytor.com>,
       "John Linn" <linnj@xilinx.com>, <monstr@seznam.cz>,
       <drepper@redhat.com>, <alan@lxorguk.ukuu.org.uk>
X-OriginalArrivalTime: 01 Jul 2008 15:58:44.0473 (UTC) FILETIME=[56E73E90:01C8DB93]
Message-ID: <20080701155845.9DDE299004D@mail180-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Doing this at the binary level would be nice, but I see enough problems
just doing it at the source level and at least for my purposes, doing it
on a dtb would be overkill, I think.   

The main difficulty remains how to deal with cross references between
nodes in a reasonable way where the references cross from one fragment
to another.

Steve

> -----Original Message-----
> From: Benjamin Herrenschmidt [mailto:benh@kernel.crashing.org]
> Sent: Monday, June 30, 2008 11:22 PM
> To: Stephen Neuendorffer
> Cc: John Williams; grant.likely@secretlab.ca;
linux-arch@vger.kernel.org; Michal Simek;
> vapier.adi@gmail.com; arnd@arndb.de; matthew@wil.cx;
microblaze-uclinux@itee.uq.edu.au; linux-
> kernel@vger.kernel.org; linuxppc-dev@ozlabs.org;
will.newton@gmail.com; hpa@zytor.com; John Linn;
> monstr@seznam.cz; drepper@redhat.com; alan@lxorguk.ukuu.org.uk
> Subject: RE: [PATCH 12/60] microblaze_v4: Generic dts file for
platforms
> 
> 
> > As for the copyright, I haven't been able to find much information
on
> > whether or not generated files are even copyrightable.  One might
> > argue that they
> > don't have sufficient 'creative value' to be copyrightable.  Or
> > arguably, they are as copyrightable by the generator author as by
the
> > author or the .mhs file.
> > I admit in this case, I've followed the safe route by claiming a
> > copyright, which at least at Xilinx has significant precedent.
> 
> Also, thinking about your idea of sticking bits in BRAM etc...
> 
> what would be nice would be the ability to "merge" trees. We've been
> talking about that multiple times, it would be useful at several
levels:
> 
>  - We could provide pre-made DTs for known CPUs (ie, 440GP, 440GX,
> 405EX, ...)
>  - Boards can then include that, and then "override" some properties
> (clocks, PHY wiring, ...)
>  - That could be done at the binary level too so that the BRAM
contains
> on "overlay" on top of the base ref. platform device-tree that comes
> with the kernel for example.
> 
> This is slightly different between doing that in the .dts source via
> some kind of #include vs. doing that by merging blobs but we could
make
> it be essentially be the same internally: The #include generates a
blob
> that is then "merged in".
> 
> Just random thoughts...
> 
> Ben.
> 
> 


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


