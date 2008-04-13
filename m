Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYDMA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYDMA0b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 20:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYDMA0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 20:26:23 -0400
Received: from smtp.ono.com ([62.42.230.12]:62098 "EHLO resmaa02.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753544AbYDMA0W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 20:26:22 -0400
Date: Sun, 13 Apr 2008 02:26:19 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: DRDY errors again
Message-ID: <20080413022619.2890f6f3@werewolf.home>
In-Reply-To: <47FB9677.30109@garzik.org>
References: <20080408171311.69441c8b@werewolf>
	<47FB9677.30109@garzik.org>
X-Mailer: Claws Mail 3.3.1cvs55 (GTK+ 2.12.9; i686-pc-linux-gnu)
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
> Can you bisect to see when this problem starts?  I'm pretty sure it's 
> software, either interrupt-related or the libata driver itself.
> 
> See http://ata.wiki.kernel.org/index.php/Libata_error_messages for a 
> full explanation of that error message.
> 
> Most notable:  "DRDY" == device ready == device says everything is OK, 
> from it's perspective.  "timeout" usually means an interrupt wasn't 
> delivered from your ATA controller, when we were expecting one.
> 

I'm trying to get a good starting point for bisection, but at 2.6.22
it still begins to give errors at a few seconds of start copying:

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd 35/00:00:77:0a:c2/00:04:1c:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4: soft resetting port
ata4.00: configured for UDMA/133
ata4: EH complete
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd 35/00:00:47:71:11/00:04:1d:00:00/e0 tag 0 cdb 0x0 data 524288 out
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4: soft resetting port
ata4.00: configured for UDMA/133
ata4: EH complete
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA

I will have to go backwards more and more...

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
