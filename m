Return-Path: <linux-kernel-owner+w=401wt.eu-S1030308AbXEAEd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308AbXEAEd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXEAEd0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:33:26 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:30883 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030308AbXEAEdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:33:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=uYbZUui9tCSddjV7FS/j/F8mp3qnuAO4cFHiT4MxQgdqLB9RLdczFEBqXb21Qjk32hPIfNxWY4sPfdjYQ4PnblroeGvJCfPnYL6xx/6L45BE5JQg5hqm4sawuNqj15LobNLv1OmC8rs1zmKH4eYuw6ugFYsIEnq3Kc0rOPRbemM=
Message-ID: <4636C2C7.8090206@gmail.com>
Date: Tue, 01 May 2007 06:32:07 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: William Thompson <wt@electro-mechanical.com>
CC: linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       albertcc@tw.ibm.com
Subject: Re: 2.6.20 libata cdrom
References: <20070427175205.GD7809@electro-mechanical.com> <4635C35D.1020807@gmail.com> <20070430202107.GF5942@electro-mechanical.com>
In-Reply-To: <20070430202107.GF5942@electro-mechanical.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-ide and Albert, Hi!]

William Thompson wrote:
> On Mon, Apr 30, 2007 at 12:22:21PM +0200, Tejun Heo wrote:
>> William Thompson wrote:
>>> I've been playing with libata on a few machines and I found that this machine
>>> (An old Dell Dimension L866r) gives me this when it loads and does not give me
>>> access to the cdrom.  This is the only machine that I've tested that I know
>>> for a fact cannot do DMA on the cdrom.  I searched and noticed a similar
>>> problem with 2.6.19-rc versions but I'm not sure if it's the same problem.
>>>
>>> dmesg output:
>>> libata version 2.00 loaded.
>>> ata_piix 0000:00:1f.1: version 2.00ac7
>>> PCI: Setting latency timer of device 0000:00:1f.1 to 64
>>> ata1: PATA max UDMA/66 cmd 0x1F0 ctl 0x3F6 bmdma 0xFFA0 irq 14
>>> ata2: PATA max UDMA/66 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
>>> scsi0 : ata_piix
>>> ata1.00: ATA-4, max UDMA/33, 10018890 sectors: LBA
>>> ata1.00: ata1: dev 0 multi count 16
>>> ata1.00: configured for UDMA/33
>>> scsi1 : ata_piix
>>> ata2.00: failed to IDENTIFY (I/O error, err_mask=0x1)
>> Hmm... IDENTIFY failed on the second port.  How reproducible is the
>> problem?  Every time?  Does it work with the IDE driver?  If so, please
>> post the result of 'hdparm -I /dev/hdX'.
> 
> Reproducible?  Everytime
> 
> Yes, it works fine with the IDE driver, so long as DMA is disabled.
> 
> hdparm -I:
> /dev/hdc:
> 
> ATAPI CD-ROM, with removable media
>         Model Number:           Lite-On LTN483S 48x Max
>         Serial Number:
>         Firmware Revision:      PD02
> Standards:
>         Used: ATAPI for CD-ROMs, SFF-8020i, r2.5
>         Supported: CD-ROM ATAPI-1
> Configuration:
>         DRQ response: <=10ms with INTRQ
>         Packet size: 12 bytes
> Capabilities:
>         LBA, IORDY(can be disabled)
>         DMA: sdma0 sdma1 sdma2 mdma0 mdma1 mdma2 udma0 udma1 *udma2
>              Cycle time: min=120ns recommended=120ns
>         PIO: pio0 pio1 pio2 pio3 pio4
>              Cycle time: no flow control=120ns  IORDY flow control=120ns

The err_mask is AC_ERR_DEV indicating that the device raised aborted the
IDENTIFY command.  I wonder what's going on.

Can you change "#undef ATA_DEBUG" in include/linux/libata.h to "#define
ATA_DEBUG" and report the resulting dmesg?  There will be a LOT of
messages so you probably want to increase printk buffer size and detach
other devices if possible.  It would be best if your root device isn't
driven by libata so that you can just insert the module and store the
resulting dmesg.

Thanks.

-- 
tejun
