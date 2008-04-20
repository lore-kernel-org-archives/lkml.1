Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbYDTWlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbYDTWlh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753274AbYDTWla
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:41:30 -0400
Received: from smtp.ono.com ([62.42.230.12]:54117 "EHLO resmaa01.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753046AbYDTWl3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:41:29 -0400
Date: Mon, 21 Apr 2008 00:41:26 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: linux-ide@vger.kernel.org, Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linus-IDE <linux-ide@vger.kernel.org>
Subject: Re: DRDY errors again
Message-ID: <20080421004126.3191dbfe@werewolf.home>
In-Reply-To: <47FB9677.30109@garzik.org>
References: <20080408171311.69441c8b@werewolf>
	<47FB9677.30109@garzik.org>
X-Mailer: Claws Mail 3.4.0cvs3 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Apr 2008 11:59:51 -0400, Jeff Garzik <jeff@garzik.org> wrote:

> J.A. Magallón wrote:
> > scsi4 : ata_piix
> > scsi5 : ata_piix
> > ata3: SATA max UDMA/133 cmd 0xc000 ctl 0xc400 bmdma 0xd000 irq 18
> > ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xcc00 bmdma 0xd008 irq 18
> 
> > ata4.00: ATA-8: ST3500820AS, SD25, max UDMA/133
> > ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> > ata4.00: configured for UDMA/133
> 
> > ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> > ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
> >          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> > ata4.00: status: { DRDY }
> 

I'm still trying to dig this...

After googling sometime I saw several reports like mine (it looks like a too
common problem). In those repots, kernel messages were a bit different from
mine. For example, from http://marc.info/?l=linux-kernel&m=119498755206823&w=2:

ata1.00: status: { DRDY }
ata1: soft resetting link
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/133
ata1: EH complete

Why I don't have any "SATA link up..." message ?

And at device init, some logs read like:

ata1.00: ATA-8: WDC WD2500BEVS-22UST0, 01.01A01, max UDMA/133
ata1.00: 488397168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133

Mine is like:

ata3.00: ATA-8: WDC WD3200AVJS-63WDA0, 12.01B02, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)  <===== 0, not 31 ??
ata3.00: configured for UDMA/133
ata4.00: ATA-8: ST3500820AS, SD25, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)  <===== 0, not 31 ??
ata4.00: configured for UDMA/133

Just to see if I have some strange behaviour...

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
