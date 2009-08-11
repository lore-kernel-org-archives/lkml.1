Return-Path: <linux-kernel-owner+w=401wt.eu-S1754223AbZHKQTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223AbZHKQTQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 12:19:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZHKQTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 12:19:16 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:28298
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751543AbZHKQTP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 12:19:15 -0400
X-SpamScore: -15
X-BigFish: VPS-15(zz1432R1521Mzz1202hzzz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [microblaze-uclinux] Rethinking MicroBlaze commandline precedence
Date: Tue, 11 Aug 2009 09:18:54 -0700
In-Reply-To: <4A81185A.6090206@petalogix.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [microblaze-uclinux] Rethinking MicroBlaze commandline precedence
Thread-Index: AcoaU0WuasVsctMfQMSccp8i3TMOagASzzSQ
References: <1d3f23370908092328l6e980f3ft2d5a8f8f37c26fcf@mail.gmail.com>	 <4A7FCC42.40809@petalogix.com> <1d3f23370908100156q46b9869av5ecdcc8879617be9@mail.gmail.com> <4A7FE78F.4040504@petalogix.com> <20090810164242.05DE8CC8055@mail83-dub.bigfish.com> <4A81185A.6090206@petalogix.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <microblaze-uclinux@itee.uq.edu.au>
CC: "John Linn" <linnj@xilinx.com>, "David DeBonis" <ddeboni@xilinx.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 11 Aug 2009 16:19:10.0374 (UTC) FILETIME=[754F6460:01CA1A9F]
Message-ID: <20090811161911.31858AF0053@mail161-va3.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>>>> So, how about this order instead:
> >>>>>
> >>>>> 1. CONFIG_CMDLINE=...
> >>>>> 2. "chosen" section in DTS/DT
> >>>>> 3. pointer in r5 from bootloader
> >>>>> 4. CONFIG_CMDLINE=... and CONFIG_CMDLINE_FORCE
> >>>>>
> >>>>> Then, apart from CMDLINE_FORCE, the precedence goes from
earliest
> >>>>> binding (kernel build) to latest (runtime via bootloader/r5).
> >
> > This makes reasonable sense to me, although I wonder if the order is
> > correct?  For instance, in many cases a flow may be to fix the
hardware
> > DTS and then iteratively compile the kernel?  Are all of these
> > points/fallback priorities necessary?  Personally, it seems like I
want
> > one 'compiled-in' source, and then the option to override at boot
time.
> > Could it be simplified by getting rid CONFIG_CMDLINE alltogether and
> > just using the DTS, now that this we always have a device tree?
> 
> From my point of view that CONFIG_CMDLINE_FORCE make perfectly sense
to be sure
> that no one else change my command line.

If there weren't so many options, maybe there wouldn't be so many places
to get it wrong?

> >>>> I understand that you are trying to pass to kernel for example
MTD
> > map which could be possible but
> >>>> IMHO better to do this in script which one with sed
> > erase/comment/setup command line in DTS before
> >>>> compilation.
> >>> It's still a very early binding, and I think there are plenty of
> >>> reasons to want to override it at boot time.  If there weren't,
why
> > do
> >>> u-boot and PPC simpleBoot add the capability to tweak at boot
time,
> >>> the cmdline passed via the DTB?
> >> I understand that make sense to change it - especially for
> > development.
> >> It should be possible to do it in u-boot. Not sure if is work to
> > extend command line but maybe yes.
> >> Worth to ask on u-boot mailing list.
> >
> > One way around this is to do what powerpc has: a simple bootloader
with
> > the capability to edit the cmdline on the terminal before boot.
Then
> > the question of 'does someone have a bootloader' is moot... they can
> > always fall back on that one.  This would also make microblaze arch
more
> > in the spirit of EPapr, which exactly tries to standardize all of
these
> > mechanisms.
> 
> NO. I understand that you like PowerPC and in many cases is PowerPC
good
> example but create next simple bootloader just for changing command
line.
> For final products is definitely useless. For developing we recommend
you to use
> U-BOOT.
> IIRC on ppc you have to wait some sec to continue - this extend
booting time.
> I believe that we want to fast boot as is possible.

I'm not suggesting that this is what should always be done.  Generally
speaking,
I prefer u-boot as well, however, if the problem is
that a user may not have a bootloader, then it is a reasonable
assumption you could make.
IMO, microblaze tries to do alot of initialization in the kernel proper,
which may or may
not be a good idea.  PowerPC avoids some of these issues by simply
assuming there is always
*some* sort of bootloader.

> Do you have any link to that standard?

I think it is publicly accessibly at power.org.  Generally the goal is
to attempt to standardize on the mechanism of passing parameters like
the command line to the kernel.  Nothing is explicitly disallowed, but
the preferred way to pass information of any type is in a structured
device tree.

Steve

This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


