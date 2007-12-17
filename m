Return-Path: <linux-kernel-owner+w=401wt.eu-S933628AbXLQAc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbXLQAc3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 19:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbXLQAcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 19:32:21 -0500
Received: from mail.tmr.com ([64.65.253.246]:53464 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753744AbXLQAcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 19:32:19 -0500
Message-ID: <4765C7E8.8010107@tmr.com>
Date: Sun, 16 Dec 2007 19:50:48 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: trash can <thetrashcan@earthlink.net>
CC: Mark Lord <liml@rtr.ca>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org, ide <linux-ide@vger.kernel.org>
Subject: Re: Iomega ZIP-100 drive unsupported with jmicron JMB361 chip?
References: <fa.yONLBG7CMuz80f4dUP5r/5k7emw@ifi.uio.no> <475DD7FF.4030906@shaw.ca> <475EAEDD.9090905@earthlink.net> <475EC0D1.8010200@rtr.ca> <475EC163.8070305@rtr.ca> <475EDF76.4000703@earthlink.net> <475EE560.6040601@rtr.ca> <47603532.7060008@earthlink.net>
In-Reply-To: <47603532.7060008@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trash can wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Success!
> I downloaded kernel-2.6.24-0.81.rc4.git7.fc9.src.rpm from the Fedora
> development tree. Went through "rpm dependecy hell" and solved all
> dependencies by installing other fc9 rpms. I used
> config-2.6.23.1-42.fc8 as my starting point. My
> config-2.6.24-0.81.rc4.git7.local.fc8 is attached.
> 
> After compilation and installation of the kernel rpm, upon boot I could
> see a device sdc4 being created, but boot failed with
> "mount: missing mount point", some errors in mounting from setuproot and
> switchroot.
> 
> I believe the problem was with the Red Hat/Fedora anaconda installer
> and/or grub, and my multiboot machine setup. I had not been able to boot
> updated fc8 kernel packages, only the originally installed kernel.
> Note that my Fedora 7 and Fedora 8 distributions share no directories
> (one exception) and all this work is taking place in the Fedora 8
> distribution. The /boot partition IS shared among my distributions.
> I found my /etc/fstab file had two "/" mount point entries. The last line
> contained LABEL=/ and is a reference to my Fedora 7 root partition.
> I deleted this line from fstab as I did not want to change the mount
> point for this line to mount my Fedora 7 distribution on Fedora 8.
> This kernel installation process was appending LABEL=/ to my kernel
> line in grub.conf:
> kernel /vmlinuz-2.6.24-0.81.rc4.git7.local.fc8 ro root=/dev/VGf800/LogVol00 rhgb quiet LABEL=/
> 
> LABEL=/ was removed from the line.
> 
> I then needed to recreate my initrd image:
> mkinitrd /boot/initrd-2.6.24-0.81.rc4.git7.local.fc8.img \
>   2.6.24-0.81.rc4.git7.local.fc8
> 
> Finally I was able to boot (Zip disk inserted) to the local kernel and the
> Zip drive works as expected.
> 
> # blkid
> /dev/sdc4: SEC_TYPE="msdos" LABEL="ZIP-100" UUID="4910-1305" TYPE="vfat"
> 
> dmesg:
> ata9.00: ATAPI: LITE-ON DVDRW SOHW-1693S, KS0B, max UDMA/66
> ata9.01: ATAPI: IOMEGA  ZIP 100       ATAPI, 05.H, max MWDMA1, CDB intr
> ata9.00: limited to UDMA/33 due to 40-wire cable
> ata9.00: configured for UDMA/33
> ata9.01: configured for MWDMA1
> scsi 8:0:0:0: CD-ROM            LITE-ON  DVDRW SOHW-1693S KS0B PQ: 0 ANSI: 5
> scsi 8:0:1:0: Direct-Access     IOMEGA   ZIP 100          05.H PQ: 0 ANSI: 5
> sd 8:0:1:0: [sdc] 196608 512-byte hardware sectors (101 MB)
> sd 8:0:1:0: [sdc] Write Protect is off
> sd 8:0:1:0: [sdc] Mode Sense: 00 40 00 00
> sd 8:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
> sd 8:0:1:0: [sdc] 196608 512-byte hardware sectors (101 MB)
> sd 8:0:1:0: [sdc] Write Protect is off
> sd 8:0:1:0: [sdc] Mode Sense: 00 40 00 00
> sd 8:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
>  sdc: sdc4
> 
> My thanks to all the great people who solved this problem and those who patiently
> responded to my queries.
> 
> - -RoyBoy626
> 
I've been behing reading this list, I was going to say that I have 
always had best luck with those drives using the old idescsi driver, 
although I haven't used a kernel newer than... 2.6.18 or so on the old 
machines. Since you have a solution I won't suggest you try that with an 
old kernel ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
