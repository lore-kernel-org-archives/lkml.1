Return-Path: <linux-kernel-owner+w=401wt.eu-S1759985AbYDBTG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759985AbYDBTG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759298AbYDBTGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:06:15 -0400
Received: from fizeau.zen.co.uk ([212.23.8.67]:57338 "EHLO fizeau.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759239AbYDBTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:06:14 -0400
X-Greylist: delayed 1100 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Apr 2008 15:06:13 EDT
Subject: Re: WD SATA disk works on nv but not on ahci
From: Matt Keenan <tank.en.mate@gmail.com>
To: Michael Stapelberg <michael+lkml@stapelberg.de>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080402173429.GS11237@mx01>
References: <20080402173429.GS11237@mx01>
Content-Type: text/plain
Date: Wed, 02 Apr 2008 19:45:34 +0100
Message-Id: <1207161934.2042.3.camel@bazbox.opcode-solutions.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-Originating-Pythagoras-IP: [82.69.27.224]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-04-02 at 19:34 +0200, Michael Stapelberg wrote:
> Hi,
> 
> I recently bought an MSI 945GT Speedster-A4V which got an Intel 82801GR/GH
> (ICH7 Family) SATA AHCI Controller onboard. The complete lspci-Output follows
> below.
> 
> I also have a WD 250 GB SATA disk since about a year, it's an WDC
> WD2500YD-01N. This disk ran on an ASUS A8N-SLI flawlessly for over a year. It
> also works on an MSI K9N (also nvidia-chipset) flawlessy right now, I just
> tested it.
> 
> When I use this disk on my MSI 945GT it throws SATA Exceptions like this on
> nearly every access to the disk (reading via dd for example):
> Apr  2 18:11:45 w ata5.00: exception Emask 0x52 SAct 0x1 SErr 0x1480c01 action 0x6 frozen
> Apr  2 18:11:45 w ata5.00: irq_stat 0x08000000, interface fatal error
> Apr  2 18:11:45 w ata5: SError: { RecovData Proto HostInt 10B8B Handshk TrStaTrns }
> Apr  2 18:11:45 w ata5.00: cmd 60/00:00:10:90:0d/02:00:00:00:00/40 tag 0 ncq 262144 in
> Apr  2 18:11:45 w res 40/00:04:10:90:0d/00:00:00:00:00/40 Emask 0x52 (ATA bus error)
> Apr  2 18:11:45 w ata5.00: status: { DRDY }
> Apr  2 18:11:45 w ata5: hard resetting link
> Apr  2 18:11:51 w ata5: port is slow to respond, please be patient (Status 0x80)
> Apr  2 18:11:56 w ata5: COMRESET failed (errno=-16)
> Apr  2 18:11:56 w ata5: hard resetting link
> Apr  2 18:11:56 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Apr  2 18:11:56 w ata5.00: configured for UDMA/133
> Apr  2 18:11:56 w ata5: EH complete
> Apr  2 18:11:56 w ata5.00: exception Emask 0x10 SAct 0x1 SErr 0x400100 action 0x2 frozen
> Apr  2 18:11:56 w ata5.00: irq_stat 0x08000000, interface fatal error
> Apr  2 18:11:56 w ata5: SError: { UnrecovData Handshk }
> Apr  2 18:11:56 w ata5.00: cmd 61/08:00:20:28:00/00:00:00:00:00/40 tag 0 ncq 4096 out
> Apr  2 18:11:56 w res 40/00:04:20:28:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
> Apr  2 18:11:56 w ata5.00: status: { DRDY }
> Apr  2 18:11:56 w ata5: soft resetting link
> Apr  2 18:11:57 w ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> Apr  2 18:11:57 w ata5.00: configured for UDMA/133
> Apr  2 18:11:57 w ata5: EH complete
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write Protect is off
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] 490234752 512-byte hardware sectors (251000 MB)
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write Protect is off
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> Apr  2 18:11:57 w sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> 
> This is really annoying and so I tried debugging the problem... When attaching
> my WD Raptor 74 GB (WDC WD740GD-00FL), there are no problems at all. I can
> read the whole disk without a single error. This rules out problems with SATA
> cables and power supply, I think. The cable is the same which I used the year
> before.
> 
> I also tried switching between IDE/AHCI-mode in the BIOS, but neither works
> correctly. IDE-mode just spits out error messages and doesn't work at all,
> AHCI produces the errors I talked about above.
> 
> I'm using kernel 2.6.24.3 at the moment.
> 
> This is a really strange problem in my opinion, could it be an incompatibility
> in the SATA protocol of this drive? Just to stress it, the drive works on an
> nvidia chipset and another drive works on the ICH7R, just this very combination
> got problems.
> 

What's your NCQ queue length for these drives?

# for dev in /sys/block/sd*/device/queue_depth ; do echo -n "$dev: " ; \
cat $dev ; done


I have found problems with some WDC drives and NCQ on SB600 controllers
(and again no probs on nv SATA).

Matt


