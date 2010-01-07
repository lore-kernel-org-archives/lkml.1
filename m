Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199Ab0AGVul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab0AGVul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:50:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368Ab0AGVui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:50:38 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52289 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0AGVuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:50:37 -0500
Date: Thu, 7 Jan 2010 22:49:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Garzik <jeff@garzik.org>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.33-rc0 regression: 256MB CF card no longer recognized in
 PCMCIA slot
Message-ID: <20100107214940.GA25698@elf.ucw.cz>
References: <20091219215459.GB9011@elf.ucw.cz>
 <4B2D54E7.9060508@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2D54E7.9060508@garzik.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-12-19 17:34:15, Jeff Garzik wrote:
> On 12/19/2009 04:55 PM, Pavel Machek wrote:
> >Hi!
> >
> >Subject pretty much says it all... I do get some messages on the
> >console, I'll try to gather them.
> 
> Which driver(s) no longer see it?  Do you think it's the PCMCIA
> subsystem, IDE, libata or other?

Not sure. The messages I get with -rc1 are:


Dec 26 10:51:43 amd log1n[1798]: ROOT LOGIN on `tty8'
Dec 26 10:51:59 amd kernel: pcmcia_socket pcmcia_socket0: pccard:
PCMCIA card inserted into slot 0
Dec 26 10:51:59 amd kernel: pcmcia_socket pcmcia_socket0: cs: memory
probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
Dec 26 10:51:59 amd kernel: pcmcia_socket pcmcia_socket0: cs: memory
probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
0xe4e70000-0xe523ffff 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff

2.6.33-rc2 says:

Dec 26 10:54:38 amd kernel: pcmcia_socket pcmcia_socket0: pccard:
PCMCIA card inserted into slot 0
Dec 26 10:54:38 amd kernel: pcmcia_socket pcmcia_socket0: cs: memory
probe 0xe0000000-0xe3ffffff: excluding 0xe0000000-0xe3ffffff
Dec 26 10:54:38 amd kernel: pcmcia_socket pcmcia_socket0: cs: memory
probe 0xe4300000-0xe7ffffff: excluding 0xe4300000-0xe46cffff
0xe4e70000-0xe523ffff 0xe5db0000-0xe617ffff 0xe6cf0000-0xe70bffff
Dec 26 10:54:38 amd kernel: pcmcia 0.0: pcmcia: registering new device
pcmcia0.0
Dec 26 10:54:38 amd kernel: scsi6 : pata_pcmcia
Dec 26 10:54:38 amd kernel: ata7: PATA max PIO0 cmd 0x9100 ctl 0x910e
irq 16
Dec 26 10:54:39 amd kernel: ata7.00: CFA: Transcend, 2N3-0925, max
PIO2
Dec 26 10:54:39 amd kernel: ata7.00: 503808 sectors, multi 0: LBA
Dec 26 10:54:39 amd kernel: ata7.00: configured for PIO0
Dec 26 10:54:39 amd kernel: ata7.00: configured for PIO0
Dec 26 10:54:39 amd kernel: ata7: EH complete
Dec 26 10:54:39 amd kernel: isa bounce pool size: 16 pages
Dec 26 10:54:39 amd kernel: scsi 6:0:0:0: Direct-Access     ATA
Transcend        2N3- PQ: 0 ANSI: 5
Dec 26 10:54:39 amd kernel: sd 6:0:0:0: Attached scsi generic sg1 type
0
Dec 26 10:54:39 amd kernel: sd 6:0:0:0: [sdb] 503808 512-byte logical
blocks: (257 MB/246 MiB)
Dec 26 10:54:39 amd kernel: sd 6:0:0:0: [sdb] Write Protect is off
Dec 26 10:54:39 amd kernel: sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
Dec 26 10:54:39 amd kernel: sd 6:0:0:0: [sdb] Write cache: disabled,
read cache: enabled, doesn't support DPO or FUA
Dec 26 10:54:39 amd kernel:  sdb: sdb1
Dec 26 10:54:39 amd kernel: sd 6:0:0:0: [sdb] Attached SCSI removable
disk
Dec 26 10:54:56 amd kernel: wlan0: deauthenticated from
00:11:95:05:30:d7 (Reason: 3)


...so this can be closed as "fixed in -rc2".
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
