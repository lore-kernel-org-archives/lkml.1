Return-Path: <linux-kernel-owner+w=401wt.eu-S1755514AbXKXSGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbXKXSGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752978AbXKXSG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:06:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:32882 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751830AbXKXSG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:06:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan-Simon =?iso-8859-1?q?M=F6ller?= <dl9pf@gmx.de>
Subject: Re: sata NCQ blacklist entry
Date: Sat, 24 Nov 2007 19:24:23 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com> <20071122232109.efdbf1b4.akpm@linux-foundation.org> <200711240050.07236.dl9pf@gmx.de>
In-Reply-To: <200711240050.07236.dl9pf@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200711241924.23850.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 24 of November 2007, Jan-Simon Möller wrote:
> Am Freitag 23 November 2007 08:21:09 schrieb Andrew Morton:
> > On Tue, 13 Nov 2007 21:55:15 +0100 Jan-Simon M__ller <dl9pf@gmx.de> wrote:
> > > Hi!
> >
> > You removed from cc the guys who are most likely to fix this.  Please
> > always do reply-to-all.
> Sri, will remember that.
> >
> > > Just using kernel 2.6.24-rc2 (325d22df7b19e0116aff3391d3a03f73d0634ded).
> > >
> >
> > So is this problem (which in another email you attributed to smartd) 
> Even without smartd in my default runlevel it happens at some point.
> 
> > also 
> > present in 2.6.23?
> I compiled and tested 2.6.23.8. Smartd enabled, nothing noticed, dmesg is 
> really clean:
> dmesg | grep ata
> ACPI: SSDT 7F6D3C3F, 02DD (r1 SataRe SataAhci     1000 INTL 20060912)
> PERCPU: Allocating 46888 bytes of per cpu data
> Memory: 2042960k/2087744k available (2062k kernel code, 44396k reserved, 982k 
> data, 324k init)
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> libata version 2.21 loaded.
> ata1: SATA max UDMA/133 cmd 0xffffc2000034e100 ctl 0x0000000000000000 bmdma 
> 0x0000000000000000 irq 4347
> ata2: SATA max UDMA/133 cmd 0xffffc2000034e180 ctl 0x0000000000000000 bmdma 
> 0x0000000000000000 irq 4347
> ata3: SATA max UDMA/133 cmd 0xffffc2000034e200 ctl 0x0000000000000000 bmdma 
> 0x0000000000000000 irq 4347
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-8: WDC WD2500BEVS-22UST0, 01.01A01, max UDMA/133
> ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> ata2: SATA link down (SStatus 0 SControl 300)
> ata3: SATA link down (SStatus 0 SControl 300)
> ata_piix 0000:00:1f.1: version 2.12
> scsi3 : ata_piix
> scsi4 : ata_piix
> ata4: PATA max UDMA/100 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 
> 0x0000000000011810 irq 14
> ata5: PATA max UDMA/100 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 
> 0x0000000000011818 irq 15
> ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WW01, max UDMA/33
> ata4.00: configured for UDMA/33
> EXT3-fs: mounted filesystem with ordered data mode.
> 
> 
> 
> >
> > And is is still present in 2.6.24-rc3?
> Went back to 2.6.24-rc3 ...
> Yes, but not at boot when smartd is started.
> 
> dmesg | grep ata
> ACPI: SSDT 7F6D3C3F, 02DD (r1 SataRe SataAhci     1000 INTL 20060912)
> PERCPU: Allocating 46968 bytes of per cpu data
> Memory: 2048732k/2087744k available (2219k kernel code, 38624k reserved, 992k 
> data, 344k init)
> ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
> libata version 3.00 loaded.
> ata1: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404100 irq 4347
> ata2: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404180 irq 4347
> ata3: SATA max UDMA/133 abar m2048@0xfc404000 port 0xfc404200 irq 4347
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: ATA-8: WDC WD2500BEVS-22UST0, 01.01A01, max UDMA/133
> ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
> ata1.00: configured for UDMA/133
> ata2: SATA link down (SStatus 0 SControl 300)
> ata3: SATA link down (SStatus 0 SControl 300)
> ata_piix 0000:00:1f.1: version 2.12
> scsi3 : ata_piix
> scsi4 : ata_piix
> ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
> ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
> ata4.00: ATAPI: HL-DT-ST DVDRAM GSA-T20N, WW01, max UDMA/33
> ata4.00: configured for UDMA/33
> EXT3-fs: mounted filesystem with ordered data mode.
> ata1.00: exception Emask 0x2 SAct 0x73 SErr 0x0 action 0x2 frozen
> ata1.00: spurious completions during NCQ issue=0x0 SAct=0x73 
> FIS=004040a1:00000008
> ata1.00: cmd 60/10:00:d4:82:31/00:00:07:00:00/40 tag 0 cdb 0x0 data 8192 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/08:08:9c:e5:cc/00:00:08:00:00/40 tag 1 cdb 0x0 data 4096 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/10:20:24:61:25/00:00:09:00:00/40 tag 4 cdb 0x0 data 8192 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/58:28:c4:65:25/00:00:09:00:00/40 tag 5 cdb 0x0 data 45056 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/20:30:7c:f6:a3/00:00:05:00:00/40 tag 6 cdb 0x0 data 16384 in
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/133
> ata1: EH complete
> ata1.00: exception Emask 0x2 SAct 0x187 SErr 0x0 action 0x2 frozen
> ata1.00: spurious completions during NCQ issue=0x0 SAct=0x187 
> FIS=004040a1:00000040
> ata1.00: cmd 60/08:00:ec:af:10/00:00:04:00:00/40 tag 0 cdb 0x0 data 4096 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/10:08:8c:e6:d8/00:00:04:00:00/40 tag 1 cdb 0x0 data 8192 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 60/20:10:24:1a:da/00:00:04:00:00/40 tag 2 cdb 0x0 data 16384 in
> ata1.00: status: { DRDY }
> ata1.00: cmd 61/01:38:15:b3:30/00:00:07:00:00/40 tag 7 cdb 0x0 data 512 out
> ata1.00: status: { DRDY }
> ata1.00: cmd 61/10:40:1c:b3:30/00:00:07:00:00/40 tag 8 cdb 0x0 data 8192 out
> ata1.00: status: { DRDY }
> ata1: soft resetting link
> ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> ata1.00: configured for UDMA/133
> ata1: EH complete

Please visit http://bugzilla.kernel.org/show_bug.cgi?id=9446 and provide the
information requested by Comment #1.

Thanks,
Rafael
