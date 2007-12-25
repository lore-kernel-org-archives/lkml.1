Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbXLYJmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbXLYJmF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 04:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbXLYJlx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 04:41:53 -0500
Received: from havoc.gtf.org ([69.61.125.42]:45331 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751667AbXLYJlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 04:41:52 -0500
Date: Tue, 25 Dec 2007 04:41:52 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@osdl.org, jgarzik@pobox.com, htejun@gmail.com, pavel@suse.cz,
       rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: 2.6.24-rc6 and earlier: "host bus error" after STR
Message-ID: <20071225094151.GA9769@havoc.gtf.org>
References: <20071224204813.GA3546@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071224204813.GA3546@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2007 at 11:48:13PM +0300, Alexey Dobriyan wrote:
> Hi, I occasionally get those "soft resetting link" messages
> right after STR. Typical messages below (from photos):
> 
> 
> eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
> i8042 kbd 00:0a: activation failed
> sd 0:0:0:0: [sda] Starting disk
> ata2.01: ACPI cmd ef/03:44:00:00:00:b0 filtered out
> ata2.01: ACPI cmd ef/03:44:00:00:00:b0 filtered out
> ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
> ata2.01: configured for UDMA/66
> ata2.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
> ata2.01: ACPI cmd ef/03:45:00:00:00:b0 filtered out
> ata2.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
> ata2.01: configured for UDMA/133
> sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors (160042 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> ata2.01: ACPI cmd ef/03:42:00:00:00:a0 filtered out
> ata2.01: ACPI cmd ef/03:42:00:00:00:a0 filtered out
> ata2.01: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
> ata1.00: configured for UDMA/33
> sd 2:0:0:0: [sdb] 234441648 512-byte hardware sectors (120034 MB)
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 2:0:0:0: [sdb] Starting disk
> ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata3.00: cmd ca/00:28:ff:c0:00/00:00:00:00:00/e0 tag 0 dma 20480 out
> 	 res 51/84:28:ff:c0:00/00:00:00:00:00/e0 Emask 0x30 (host bus error)
> ata3.00: status: { DRDY ERR }
> ata3.00: error: { ICRC ABRT }
> 
> 	...
> 
> ata3: soft resetting link
> ata3: EH complete
> ata3.00: limiting speed to UDMA/100:PIO4
> ata3.00: BMDMA stat 0x6
> ata3.00: cmd ca/00:28:ff:c0:00/00:00:00:00:00/e0 tag 0 dma 20480 out
>          res 51/84:28:ff:c0:00/00:00:00:00:00/e0 Emask 0x30 (host bus error)
> ata3.00: status: { DRDY ERR }
> ata3.00: error: { ICRC ABRT }
> 
> 	...
> 
> ata3: soft resetting link
> ata3.00: configured for UDMA/100
> sd 2:0:0:0: [sdb] Result: hostbyte=0x00 driverbyte=0x08
> sd 2:0:0:0: [sdb] Sense Key: 0xb [current] [descriptor]
> Descriptor sense data with sense descriptors (in hex):
> 	72 0b 47 00 00 00 00 0[ce] 00 0a 80 00 00 00 00	/* border of photo*/
> 
> 	...
> 
> ata3.00: configured for UDMA/100
> ata3: EH complete
> sd 2:0:0:0: [sdb] ... 160G disk
> 	...
> ata3.00: limiting speed to UDMA/33:PIO4
> ata3.00: exception Emask 0x0 Sact 0x0 Serr 0x0 action 0x2
> ata3.00: BMDMA stat 0x6
> ata3.00: cmd ca/00:08:47:66:6e/00:00:00:00:00/eb tag 0 dma 4096 out
> 	 res 51/84:08:47:66:6e/00:00:00:00:00/eb Emask 0x30 (host bus error)
> ata3.00: status: { DRDY ERR }
> ata3.00: error: { ICRC ABRT }
> ata3: soft resetting link

host bus == PCI

So, your PCI bus is crapping itself in a major way.

One thing to try might be "libata.noacpi=1"

	Jeff



