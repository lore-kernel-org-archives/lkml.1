Return-Path: <linux-kernel-owner+w=401wt.eu-S1030554AbXAaTRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554AbXAaTRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 14:17:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030556AbXAaTRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 14:17:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.236]:63509 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030554AbXAaTRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 14:17:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c5wmggyBKwkxJStZN+6JVs1aJL9Win4ZCPiqxmFMzQkdM7VoQqWPgi6ESFU2LRzELLQFkQ/7ZO2YFCwS+1ctYLG90f5oS1eAXvXxEvDeHAU5EzSNvwmtSIXbzUJ50HrcJeleYEz59cOcrxm3k930b/9mVfn3xsZLFUn+EChKMas=
Message-ID: <b637ec0b0701311117x6e19715eme49ba85b2a570d31@mail.gmail.com>
Date: Wed, 31 Jan 2007 14:17:37 -0500
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: [2.6.20-rc6] pktcdvd doesn't work
Cc: "Luca Tettamanti" <kronos.it@gmail.com>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Peter Osterlund" <petero2@telia.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, justin@jmicron.com
In-Reply-To: <45C0764B.8060906@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070130195319.GA10994@dreamland.darkstar.lan>
	 <Pine.LNX.4.61.0701302100370.13737@yvahk01.tjqt.qr>
	 <20070130203601.GB15067@dreamland.darkstar.lan>
	 <Pine.LNX.4.61.0701302141420.13737@yvahk01.tjqt.qr>
	 <20070130231623.GA7648@dreamland.darkstar.lan>
	 <45C0764B.8060906@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all.
I don't know if this report can be useful, but this problem does not
show up in my setup.

I tried multiple times to copy 10MB files (unmounting and remounting
every time) and verified with md5sum the results and everything is
correct.

Details:

* kernel version: 2.6.20-rc6-g93544047
* driver: ata_piix (only a PATA hard disk and a DVD writer)
* writer: TSSTcorp CD/DVDW TS-L532M HR08 PQ: 0 ANSI: 5).
* udftools version: udftools-1.0.0b3-7.fc6

Regards,
Fabio



On 1/31/07, Jeff Garzik <jgarzik@pobox.com> wrote:
> Luca Tettamanti wrote:
> > Hi Jeff, linux-ide,
> > I'm having troubles with libata and UDF on RW media. See below.
> >
> > Il Tue, Jan 30, 2007 at 09:42:34PM +0100, Jan Engelhardt ha scritto:
> >> On Jan 30 2007 21:36, Luca Tettamanti wrote:
> >>> Il Tue, Jan 30, 2007 at 09:02:20PM +0100, Jan Engelhardt ha scritto:
> >>>> On Jan 30 2007 20:53, Luca Tettamanti wrote:
> >>>>> Hi,
> >>>>> pktcdvd on kernel 2.6.20-rc6 is not working as expected. Any file that
> >>>> Did it work previously?
> >>> Yup, It used to work but since I rarely use it I don't remember which
> >>> kernel version worked for me.
> >> Hm, maybe you can take a guess.
> >
> > I can bisect pktcdvd.c if necessary, but it seems that it's innocent.
> >
> >>>>> is written to the device is lost after umount.
> >>>>> I rarely use pktcdvd but at some point it used to work on my system.
> >>>>>
> >>>>> This is what I'm doing:
> >>>>>
> >>>>> root@dreamland:/tmp# cdrwtool -d /dev/scd0 -q
> >>>>> scsi 8:0:0:0: CD-ROM            HL-DT-ST DVDRAM GSA-4167B DL13 PQ: 0 ANSI: 5
> >>>> In case you are using ide-scsi: try without.
> >>> It's libata jmicron driver. Shall I try the "old" PATA driver on the
> >>> next reboot?
> >> If you have lots of CDRs/DVDRs to spare (or a CDRW/DVDRW), every test is
> >> welcome.
> >
> > With the legacy IDE driver it works fine.
> > The unit is DVD-RAM capable so the firmware should handle random writes
> > fine; I've tried mounting /dev/scd0 rw *without* pktcdvd and I still
> > lose files. So I guess it has something to do with libata.
> >
> > So to recap, after formatting the disk with UDF:
> >
> > * libata
> >   - mount with pktcdvd: all files are lost upon umount
> >   - mount scd0 w/out pktcdvd: all files are lost upon umount
> >   - write the disk with cdrecord: OK
> >
> >   pktcdvd reports wrong capacity:
> >
> >   pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
> >   pktcdvd: Max. media speed: 4
> >   pktcdvd: write speed 4x
> >   pktcdvd: 0kB available on disc
> >   UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2007/01/30 18:18 (103c)
> >
> > * legacy IDE driver
> >   - mount with pktcdvd: OK
> >   - mount hda w/out pktcdvd: corrupts FS (duh)
> >   - write the disk with cdrecord: OK
> >
> >   pktcdvd reports correct capacity:
> >
> >   pktcdvd: writer pktcdvd0 mapped to hda
> >   pktcdvd: Fixed packets, 32 blocks, Mode-2 disc
> >   pktcdvd: Max. media speed: 4
> >   pktcdvd: write speed 4x
> >   pktcdvd: 551232kB available on disc
> >   UDF-fs INFO UDF 0.9.8.1 (2004/29/09) Mounting volume 'LinuxUDF', timestamp 2007/01/30 22:19 (103c)
> >
> > The HW is a JMicron controller:
> > 02:00.0 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
> > 02:00.1 IDE interface: JMicron Technologies, Inc. JMicron 20360/20363 AHCI Controller (rev 02)
>
> hmmm, definitely interesting behavior.
>
> Would you mind putting this info into a bugzilla.kernel.org report, so
> that it is not lost?  This bug will likely go into a heavy ATAPI
> debugging session that is coming in a few weeks, but not immediately :/
>
>         Jeff
>
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
