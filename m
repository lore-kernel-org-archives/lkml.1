Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbXFCSxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbXFCSxg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 14:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbXFCSxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 14:53:01 -0400
Received: from web52908.mail.re2.yahoo.com ([206.190.49.18]:37524 "HELO
	web52908.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751429AbXFCSw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 14:52:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Hg4QIsa4N6Z15BVh7SBQGlHCxhA3citEpZzqlNI7J48LnkYbmP8fRTSgEHMPo1uUHPgCQtPwT49AB14m7Y6JV18AW1IyRbNWiQMMmzxSfIiV2fh4heQ3S+7zvERxNMjutLq0512NukpaJKZ5atrshz/AagwfFiKZGovtC1a4hJk=;
X-YMail-OSG: zwssoNgVM1nZ6ylO_g8BI4aBhQvganClL3An7l6nyOWFLMXBJab9jjO.sajVNywLSA--
Date: Sun, 3 Jun 2007 19:52:57 +0100 (BST)
From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [Linux 2.6.21.3] CDRW drive not recognised by PATA (ata_piix)
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4662CED4.1000506@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <488961.79733.qm@web52908.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- Jeff Garzik <jeff@garzik.org> wrote:
> Grab the 'always use polling SETXFER' patch...

Yes, that did the trick!

scsi1 : ata_piix
usb 1-2: new full speed USB device using uhci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
ata2.00: ATAPI, max UDMA/33
ata2.01: ATAPI, max UDMA/33
ata2.00: configured for UDMA/33
ata2.01: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      IC35L090AVV207-0 V23O PQ: 0 ANSI: 5
SCSI device sda: 156250000 512-byte hdwr sectors (80000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 156250000 512-byte hdwr sectors (80000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 >
sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: CD-ROM            HL-DT-ST DVD-ROM GDR8162B 0015 PQ: 0 ANSI: 5
scsi 1:0:1:0: CD-ROM            SONY     CD-RW  CRX216E   PD01 PQ: 0 ANSI: 5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
end_request: I/O error, dev fd0, sector 0
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Attached scsi generic sg1 type 5
scsi 1:0:1:0: Attached scsi generic sg2 type 5
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel E7505 Chipset.
sr0: scsi3-mmc drive: 20x/48x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0

The "pata_via" diff didn't apply, but that's OK since I'm only using ata_piix. Should a modified
version of this patch be pushed to the stable team?

Anyway, thanks for helping.
Cheers,
Chris



		
___________________________________________________________ 
Now you can scan emails quickly with a reading pane. Get the new Yahoo! Mail. http://uk.docs.yahoo.com/nowyoucan.html
