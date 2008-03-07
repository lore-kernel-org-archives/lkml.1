Return-Path: <linux-kernel-owner+w=401wt.eu-S1762628AbYCGXhP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762628AbYCGXhP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 18:37:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbYCGXhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 18:37:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44463 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932AbYCGXg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 18:36:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Commit 9f10d9ee breaks CD mounting/burning
Date: Sat, 8 Mar 2008 00:35:26 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: petkovbb@gmail.com, walt <w41ter@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200803062235.00396.bzolnier@gmail.com> <20080307214934.GB19778@gollum.tnic> <200803072345.15585.bzolnier@gmail.com>
In-Reply-To: <200803072345.15585.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803080035.27244.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 7 of March 2008, Bartlomiej Zolnierkiewicz wrote:
> On Friday 07 March 2008, Borislav Petkov wrote:
> > On Fri, Mar 07, 2008 at 09:39:43PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > On Friday 07 March 2008, Borislav Petkov wrote:
> > > > On Thu, Mar 06, 2008 at 10:35:00PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > > > > 
> > > > > On Thursday 06 March 2008, walt wrote:
> > > > > > Hi Bartolmiej,
> > > > > > 
> > > > > > For me, this commit causes the problem it's intended to fix:
> > > > > > 
> > > > > > commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
> > > > > > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > > Date:   Tue Feb 26 21:50:35 2008 +0100
> > > > > > 
> > > > > >      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
> > > > > > 
> > > > > >      This fixes some hangs caused by not finishing the transfer before ending
> > > > > >      the request and also makes use of 'ireason == 1' quirk for spurious IRQs.
> > > > > > 
> > > > > > When I mount a CD there is a long delay, and I see this error message:
> > > > > > 
> > > > > > hdc: ide_cd_check_ireason: wrong transfer direction!
> > > > > > cdrom: failed setting lba address space
> > > > > > hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > > > > > ide: failed opcode was: unknown
> > > > > > hdc: drive not ready for command
> > > > > > <repeated many times>
> > > > > > 
> > > > > > When I revert this commit everything works properly again, including
> > > > > > CD burning.
> > > > > > 
> > > > > > Here is the drive info:
> > > > > > 
> > > > > > hdc: TSSTcorpCD/DVDW SH-S182M, ATAPI CD/DVD-ROM drive
> > > > > > hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
> > > > > > hdc: UDMA/33 mode selected
> > > > > > hdc: ATAPI 48X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
> > > > > > Uniform CD-ROM driver Revision: 3.20
> > > > > > hdc: UDMA/33 mode selected
> > > > > > 
> > > > > > I'm happy to try patches or supply more info, just let me know
> > > > > > what you need.
> > > > > 
> > > > > Does the following patch help?
> > > > > 
> > > > > [ Borislav, please take a look and double check that it is OK. ]
> > > > > 
> > > > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > Subject: [PATCH] ide-cd: mark REQ_TYPE_ATA_PC write requests with REQ_RW flag
> > > > > 
> > > > > On Thursday 06 March 2008, walt wrote:
> > > > > 
> > > > > > For me, this commit causes the problem it's intended to fix:
> > > > > > 
> > > > > > commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
> > > > > > Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > > Date:   Tue Feb 26 21:50:35 2008 +0100
> > > > > > 
> > > > > >      ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests
> > > > > > 
> > > > > >      This fixes some hangs caused by not finishing the transfer before ending
> > > > > >      the request and also makes use of 'ireason == 1' quirk for spurious IRQs.
> > > > > > 
> > > > > > When I mount a CD there is a long delay, and I see this error message:
> > > > > > 
> > > > > > hdc: ide_cd_check_ireason: wrong transfer direction!
> > > > > > cdrom: failed setting lba address space
> > > > > > hdc: status error: status=0x58 { DriveReady SeekComplete DataRequest }
> > > > > > ide: failed opcode was: unknown
> > > > > > hdc: drive not ready for command
> > > > > > <repeated many times>
> > > > > > 
> > > > > > When I revert this commit everything works properly again, including
> > > > > > CD burning.
> > > > > 
> > > > > It turned out that REQ_TYPE_ATA_PC write requests were not marked as such
> > > > > (the previous commit assumed them to be).
> > > > > 
> > > > > Reported-by: walt <w41ter@gmail.com>
> > > > > Cc: Borislav Petkov <petkovbb@googlemail.com>
> > > > > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > > > ---
> > > > >  drivers/ide/ide-cd_ioctl.c |    4 ++++
> > > > >  1 file changed, 4 insertions(+)
> > > > > 
> > > > > Index: b/drivers/ide/ide-cd_ioctl.c
> > > > > ===================================================================
> > > > > --- a/drivers/ide/ide-cd_ioctl.c
> > > > > +++ b/drivers/ide/ide-cd_ioctl.c
> > > > > @@ -457,6 +457,10 @@ int ide_cdrom_packet(struct cdrom_device
> > > > >  	   layer. the packet must be complete, as we do not
> > > > >  	   touch it at all. */
> > > > >  	ide_cd_init_rq(drive, &req);
> > > > > +
> > > > > +	if (cgc->data_direction == CGC_DATA_WRITE)
> > > > > +		req.cmd_flags |= REQ_RW;
> > > > > +
> > > > >  	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
> > > > >  	if (cgc->sense)
> > > > >  		memset(cgc->sense, 0, sizeof(struct request_sense));
> > > > 
> > > > Here's how i understand it (and correct me if i'm wrong):
> > > > 
> > > > req.cmd_flags & 0x1 (i.e. the least sig. bit) was remaining unset for write requests
> > > > and that's why the ireason check in the interrupt handler was failing loudly.
> > > > This sets it correctly so that rq_data_dir(rq) evaluates to the correct data
> > > > direction of the request, no?
> > > 
> > > Yep.
> > > 
> > > Thanks for checking it, I'll push the patch to Linus.
> > 
> > Cool, can we close http://bugzilla.kernel.org/show_bug.cgi?id=10185 now?
> 
> I suppose that Rafael would prefer to close it when patch hits the mainline.

That's correct.

Thanks,
Rafael
