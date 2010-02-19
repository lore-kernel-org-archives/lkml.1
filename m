Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab0BSVEP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 16:04:15 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:61383 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754242Ab0BSVEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 16:04:10 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19326.64703.561400.379749@pilspetsen.it.uu.se>
Date: Fri, 19 Feb 2010 22:03:59 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Axel Uhl <axel.uhl@gmx.de>
Cc: Mikael Pettersson <mikpe@it.uu.se>, Tejun Heo <tj@kernel.org>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
In-Reply-To: <4B7EDE2F.8030107@gmx.de>
References: <4B72941A.7060704@gmx.de>
	<4B74BDCF.1010805@kernel.org>
	<4B74F263.1060709@gmx.de>
	<4B7505CA.60409@kernel.org>
	<4B75154B.8030507@gmx.de>
	<4B7B548B.4040606@kernel.org>
	<4B7C5696.7030609@gmx.de>
	<19325.7006.892019.748974@pilspetsen.it.uu.se>
	<4B7EDE2F.8030107@gmx.de>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Uhl writes:
 > I now enabled IO/APIC in my kernel. See attached .config. I also enabled 
 >   pata_via but was unsure which IDE driver to disable.

That would be VIA82CXXX. But all your PATA/SATA controllers are now driven
by libata, so you can disable IDE, i.e. set CONFIG_IDE=n.

 > The kernel 
 > rebooted fine. The following appeared in my syslog when the smartctl 
 > command spinned up the disk:
 > 
 > Feb 19 18:57:09 homemp3 kernel: ata5.00: exception Emask 0x0 SAct 0x0 
 > SErr 0x0 action 0x6 frozen
 > Feb 19 18:57:09 homemp3 kernel: ata5.00: failed command: SMART
 > Feb 19 18:57:09 homemp3 kernel: ata5.00: cmd 
 > b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 0
 > Feb 19 18:57:09 homemp3 kernel:          res 
 > 40/00:01:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
 > Feb 19 18:57:09 homemp3 kernel: ata5.00: status: { DRDY }
 > Feb 19 18:57:09 homemp3 kernel: ata5: soft resetting link
 > Feb 19 18:57:09 homemp3 kernel: ata5.00: configured for UDMA/133
 > Feb 19 18:57:09 homemp3 kernel: ata5: EH complete
 > 
 > 
 > At least it seems that the kernel recovered better from this exception 
 > than before. In particular, IRQ10 didn't get disabled and so I/O 
 > continued to work fine. Thanks for the hint.
 > 
 > Would you consider the exception above a serious problem that should be 
 > taken care of somehow?

Apparently this disk likes to complain when issued a SMART command while spun
down, but as libata EH recovers nicely there's no real reason to worry.
