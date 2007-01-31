Return-Path: <linux-kernel-owner+w=401wt.eu-S1161079AbXAaXid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161079AbXAaXid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 18:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161086AbXAaXic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 18:38:32 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:23675 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082AbXAaXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 18:38:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=YAtHwTvPWDPgMZNDcR67sm19GdAjU3fRCqKUQgGpH7flWysq0Pdwq+otILnIEkuVIspzxMIgzK8OgPzprvWWwntYsJ2zLTHeoh2fLcFK24muJi0mD/UPSPIHZHjENvZoHc8dIT2WO2ISC7PqFMi6cEXbHqHWI3wKm9xBWZbJadY=
Date: Thu, 1 Feb 2007 00:38:31 +0100
From: Luca Tettamanti <kronos.it@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Peter Osterlund <petero2@telia.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, justin@jmicron.com,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Message-ID: <20070131233831.GA15328@dreamland.darkstar.lan>
References: <20070130195319.GA10994@dreamland.darkstar.lan> <Pine.LNX.4.61.0701302100370.13737@yvahk01.tjqt.qr> <20070130203601.GB15067@dreamland.darkstar.lan> <Pine.LNX.4.61.0701302141420.13737@yvahk01.tjqt.qr> <20070130231623.GA7648@dreamland.darkstar.lan> <45C0764B.8060906@pobox.com> <20070131231013.GW3754@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131231013.GW3754@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Il Thu, Feb 01, 2007 at 12:10:13AM +0100, Adrian Bunk ha scritto: 
> On Wed, Jan 31, 2007 at 05:58:19AM -0500, Jeff Garzik wrote:
> > Luca Tettamanti wrote:
> > >Hi Jeff, linux-ide,
> > >I'm having troubles with libata and UDF on RW media. See below.
> > >
> > >Il Tue, Jan 30, 2007 at 09:42:34PM +0100, Jan Engelhardt ha scritto: 
> > >>On Jan 30 2007 21:36, Luca Tettamanti wrote:
> > >>>Il Tue, Jan 30, 2007 at 09:02:20PM +0100, Jan Engelhardt ha scritto: 
> > >>>>On Jan 30 2007 20:53, Luca Tettamanti wrote:
> > >>>>>Hi,
> > >>>>>pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> > >>>>Did it work previously?
> > >>>Yup, It used to work but since I rarely use it I don't remember which
> > >>>kernel version worked for me.
> > >>Hm, maybe you can take a guess.
> > >
> > >I can bisect pktcdvd.c if necessary, but it seems that it's innocent.
> > > 
> > >>>>>is written to the device is lost after umount.
> > >>>>>I rarely use pktcdvd but at some point it used to work on my system.
> > >>>>>
> > >>>>>This is what I'm doing:
> > >>>>>
> > >>>>>root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> > >>>>>scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 
> > >>>>>ANSI: 5
> > >>>>In case you are using ide-scsi: try without.
> > >>>It's libata jmicron driver. Shall I try the "old" PATA driver on the
> > >>>next reboot?
> > >>If you have lots of CDRs/DVDRs to spare (or a CDRW/DVDRW), every test is
> > >>welcome.
> > >
> > >With the legacy IDE driver it works fine.
> > >The unit is DVD-RAM capable so the firmware should handle random writes
> > >fine; I've tried mounting /dev/scd0 rw *without* pktcdvd and I still
> > >lose files. So I guess it has something to do with libata.
> > >
> > >So to recap, after formatting the disk with UDF:
> > >
> > >* libata
> > >  - mount with pktcdvd: all files are lost upon umount
> > >  - mount scd0 w/out pktcdvd: all files are lost upon umount
> > >  - write the disk with cdrecord: OK
> > >
> > >  pktcdvd reports wrong capacity:
> > >  
> > >  pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
> > >  pktcdvd: Max. media speed: 4
> > >  pktcdvd: write speed 4x
> > >  pktcdvd: 0kB available on disc
> > >  UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', 
> > >  timestamp 2007/01/30 18:18 (103c)
> > >
> > >* legacy IDE driver
> > >  - mount with pktcdvd: OK
> > >  - mount hda w/out pktcdvd: corrupts FS (duh)
> > >  - write the disk with cdrecord: OK
> > >
> > >  pktcdvd reports correct capacity:
> > >  
> > >  pktcdvd: writer pktcdvd0 mapped to hda
> > >  pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
> > >  pktcdvd: Max. media speed: 4
> > >  pktcdvd: write speed 4x
> > >  pktcdvd: 551232kB available on disc
> > >  UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', 
> > >  timestamp 2007/01/30 22:19 (103c)
> > >
> > >The HW is a JMicron controller:
> > >02:00.0 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
> > >Controller (rev 02)
> > >02:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI 
> > >Controller (rev 02)
> > 
> > hmmm, definitely interesting behavior.
> > 
> > Would you mind putting this info into a bugzilla.kernel.org report, so 
> > that it is not lost?  This bug will likely go into a heavy ATAPI 
> > debugging session that is coming in a few weeks, but not immediately :/
> 
> Is this related to #7810 (which is caused by Christoph's patches) or is 
> this issue another 2.6.20-rc pktcdvd regression?

To me it looks unrelated to #7810. In my case files are "written" to the
disk but they disappear after umount, I don't get any OOPS (nothing at
all in the log).
I'm not sure it's a regression either. As I said I rarely use pktcdvd,
it's possible that the last time I used it I still had the old
motherboard with VIA IDE controller.

Luca
-- 
Software is like sex; it's better when it's free.
Linus Torvalds
