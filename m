Return-Path: <linux-kernel-owner+w=401wt.eu-S1757843AbYDHQAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843AbYDHQAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754470AbYDHP74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:59:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48721 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbYDHP7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:59:54 -0400
Message-ID: <47FB9677.30109@garzik.org>
Date: Tue, 08 Apr 2008 11:59:51 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>
CC: "Linux-Kernel, " <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: DRDY errors again
References: <20080408171311.69441c8b@werewolf>
In-Reply-To: <20080408171311.69441c8b@werewolf>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J.A. Magallón wrote:
> scsi4 : ata_piix
> scsi5 : ata_piix
> ata3: SATA max UDMA/133 cmd 0xc000 ctl 0xc400 bmdma 0xd000 irq 18
> ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xcc00 bmdma 0xd008 irq 18

> ata4.00: ATA-8: ST3500820AS, SD25, max UDMA/133
> ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata4.00: configured for UDMA/133

> ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
> ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
>          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
> ata4.00: status: { DRDY }

Can you bisect to see when this problem starts?  I'm pretty sure it's 
software, either interrupt-related or the libata driver itself.

See http://ata.wiki.kernel.org/index.php/Libata_error_messages for a 
full explanation of that error message.

Most notable:  "DRDY" == device ready == device says everything is OK, 
from it's perspective.  "timeout" usually means an interrupt wasn't 
delivered from your ATA controller, when we were expecting one.

	Jeff


