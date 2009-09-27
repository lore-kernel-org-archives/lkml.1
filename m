Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZI0DeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZI0DeM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 23:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbZI0DeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 23:34:12 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:17038 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbZI0DeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 23:34:11 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=pm4zQ-iNRIoA:10 a=w4iE+TBsmj5y1WloLYF40w==:17 a=nxlI2F2nAAAA:8
 a=fB368q558klelpXgHGwA:9 a=4sNiWrmcjfgGA1L9qJ8A:7
 a=NfSKxPmbgc_A3PXlD7Ob13jVGK0A:4
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org
Subject: Re: mdraid causing mvsas to lockup?
Date: Sat, 26 Sep 2009 21:34:13 -0600
User-Agent: KMail/1.12.1 (Linux/2.6.31-git4; KDE/4.3.1; x86_64; ; )
Cc: linux-raid@vger.kernel.org, "linux-scsi" <linux-scsi@vger.kernel.org>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <200909181702.46109.tfjellstrom@shaw.ca> <200909211016.45679.tfjellstrom@shaw.ca>
In-Reply-To: <200909211016.45679.tfjellstrom@shaw.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200909262134.13267.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon September 21 2009, Thomas Fjellstrom wrote:
> On Fri September 18 2009, Thomas Fjellstrom wrote:
> > On Fri September 18 2009, Thomas Fjellstrom wrote:
> > > On Thu September 17 2009, Thomas Fjellstrom wrote:
> > > > On Thu September 17 2009, Kristleifur Daðason wrote:
> > > > > On Thu, Sep 17, 2009 at 11:02 PM, Thomas Fjellstrom
> > > > > <tfjellstrom@shaw.ca>
> > > >
> > > > wrote:
> > > > > > On Thu September 17 2009, John Bridges wrote:
> > > > > >> I'm a fan of the SuperMicro AOC-SAT2-MV8, great card.
> > > > > >> http://www.supermicro.com/products/accessories/addon/AOC-SAT2-MV
> > > > > >>8. cf m
> > > > > >>
> > > > > >> It's an 8 port PCI-X card, works in both PCI and PCI-X slots.
> > > > > >>
> > > > > >> SATA2
> > > > > >>
> > > > > >> Drivers for Linux are stable, built in.
> > > > > >
> > > > > > Have you had any experience with the AOC-SASLP-MV8? I've got one
> > > > > > and have been having no end of issues with it under linux.
> > > > > >
> > > > > > --
> > > > > > Thomas Fjellstrom
> > > > > > tfjellstrom@shaw.ca
> > > > > > --
> > > > >
> > > > > I have,
> > > > >
> > > > > or rather, I've tried to get an AOC-SASLP-MV8 card going. I think I
> > > > > can safely say that at least Linux kernel 2.6.31 is a requirement.
> > > > > The card was basically useless with everything up to 2.6.30, then I
> > > > > tried 2.6.31-rc5 on a whim and it kicked in. Built-in driver
> > > > > support, that is. However it wasn't stable, it dropped disks when
> > > > > syncing a large array. I've been meaning to test on 2.6.31 final,
> > > > > and am pretty optimistic.
> > > >
> > > > Yeah, the driver didn't appear till .30. I have 2.6.31-git4 installed
> > > > right now, and no matter what I do, the controller starts spewing
> > > > errors:
> > > >
> > > > [ 1455.698186] drivers/scsi/mvsas/mv_sas.c 1669:mvs_abort_task:rc= 5
> > > > [ 1455.698196] drivers/scsi/mvsas/mv_sas.c 1608:mvs_query_task:rc= 5
> > > > ...
> > > > [ 1424.708085] end_request: I/O error, dev sdh, sector 3072
> > > > [ 1424.708106] sd 0:0:3:0: [sdh] Unhandled error code
> > > > [ 1424.708111] sd 0:0:3:0: [sdh] Result: hostbyte=DID_OK
> > > > driverbyte=DRIVER_TIMEOUT
> > > > [ 1424.708118] sd 0:0:3:0: [sdh] CDB: Read(10): 28 00 00 00 08 00 00
> > > > 04 00 00
> > > >
> > > > And thats with perfectly good disks, and with smartd/hddtemp disabled
> > > > (they were causing one of my disks to barf).
> > > >
> > > > All I have to do is start a read from any disk, and after a few
> > > > minutes, the card starts erroring out, and then dies.
> > > >
> > > > It actually seems like it got more unstable from .30 to .31.
> > > >
> > > > I've been trying to get some help with it on the lkml/ide/scsi lists
> > > > for a while now, one person has tried to help, but thats about it.
> > >
> > > Very strange. I've found that reading from all 4 drives currently
> > > connected to the controller at once, works. I have 4 dd commands, one
> > > reading off each drive, and so far no errors, the dd commands aren't
> > > locking up, and they are going full speed (120MB/s per drive).
> > >
> > > If however I attempt to bring up the md raid0 array ontop of these
> > > disks, the controller locks up, and all of the disks become
> > > inaccessible.
> > >
> > > Maybe it has something to do with it, but just as the system is
> > > booting, I get the following, maybe related, maybe not:
> > >
> > > ata_id[5183]: HDIO_GET_IDENTITY failed for '/dev/block/8:96'
> > > ata_id[5188]: HDIO_GET_IDENTITY failed for '/dev/block/8:112'
> > > ata_id[5184]: HDIO_GET_IDENTITY failed for '/dev/block/8:80'
> > >
> > > (those map to sdg, sdh, and sdf in that order, no report for sde, the
> > > first disk in the controller)
> >
> > So I've let the controller and disks sit all day after finishing a full
> >  read test (dd if=/dev/sd[efgh] of=/dev/null bs=8M) with all four 1TB
> >  drives going at the same time, and I've had no errors at all. All four
> > dd commands finished without error, and went at full speed.
> >
> > If I attempt to activate an md raid0 array ontop of any disks on this
> > controller the controller starts having a fit, and all disks are
> >  inaccessible till a hard reset (the machine won't fully reboot, or turn
> >  off, as the "flushing scsi cache" or "shutting down LVM" steps will hang
> >  waiting on drives on the wedged controller.
> >
> > I would really like to get this fixed, if there's anything more I can do
> > to help narrow down the problem further, I'll do my best.
> 
> Does anyone have a clue what might be wrong? Something I could check into?
>  I have a couple system migrations to do, and this is blocking that. (my
>  old array has been making "click" noises for a year now, and I'm afraid
>  it'll die at any time)
> 

After trying to get an array up on this card, it locked up again. (the array 
that is:)

[ 1762.705866] sd 0:0:0:0: [sdc] Unhandled error code
[ 1762.705873] sd 0:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 1762.705882] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 01 77 00 02 c8 00
[ 1947.698246] sd 0:0:0:0: [sdc] Unhandled error code
[ 1947.698268] sd 0:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[ 1947.698277] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 02 3f 00 00 08 00
[ 1947.698308] __ratelimit: 79 callbacks suppressed

[13470.701276] sd 0:0:0:0: [sdc] Unhandled error code
[13470.701283] sd 0:0:0:0: [sdc] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[13470.701292] sd 0:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
[13470.701381] sd 0:0:1:0: [sdd] Unhandled error code
[13470.701385] sd 0:0:1:0: [sdd] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[13470.701393] sd 0:0:1:0: [sdd] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
[13470.701458] sd 0:0:2:0: [sde] Unhandled error code
[13470.701463] sd 0:0:2:0: [sde] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[13470.701470] sd 0:0:2:0: [sde] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00
[13470.701523] sd 0:0:3:0: [sdf] Unhandled error code
[13470.701527] sd 0:0:3:0: [sdf] Result: hostbyte=DID_OK 
driverbyte=DRIVER_TIMEOUT
[13470.701535] sd 0:0:3:0: [sdf] CDB: Read(10): 28 00 00 00 00 00 00 00 20 00

then as the fan in my hot swap bay is failing, I decided to remove the drives 
to get the unit to stop the fan. Then the entire system locked up hard, 
keyboard LEDs blinking and everything.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
