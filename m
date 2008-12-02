Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYLBOGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYLBOGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 09:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753932AbYLBOF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 09:05:56 -0500
Received: from nn7.de ([85.214.94.156]:58751 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742AbYLBOF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 09:05:56 -0500
Subject: Re: ST31500341AS vs ICH10, exception Emask 0x50 SAct 0x1 SErr
	0x280900 action 0x6 frozen
From: Soeren Sonnenburg <kernel@nn7.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux-ide <linux-ide@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812020448270.10115@p34.internal.lan>
References: <1228205289.29251.32.camel@localhost>
	 <alpine.DEB.1.10.0812020448270.10115@p34.internal.lan>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 02 Dec 2008 15:05:53 +0100
Message-Id: <1228226753.4265.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-12-02 at 04:49 -0500, Justin Piszcz wrote:
> 
> On Tue, 2 Dec 2008, Soeren Sonnenburg wrote:
> 
> > Dear all,
> >
> > I just purchased a seagate 1.5TB drive ST31500341AS, with firmware
> > revision CC1G (which according to seagate is not affected by the cache
> > flush bug) and I am getting the errors below (after almost a day of
> > uptime without problems). The drive is replacing a 750G variant from
> > seagate with which I had months of uptime and no errors whatsoever.
> >
> > I hope anyone has an idea?
> >
> > - relevant part of hdparm -I and lspci
> >
> > ATA device, with non-removable media
> > 	Model Number:       ST31500341AS
> > 	Firmware Revision:  CC1G
> > 	Transport:          Serial
> >
> > 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Family) SATA
> > AHCI Controller
> >
> > - the error(tm)
> 
> A few items:
> 
>           res 40/00:00:48:19:67/00:00:1e:00:00/40 Emask 0x50 (ATA bus error)
>           ata3: SError: { UnrecovData HostInt 10B8B BadCRC }
> 
> These are usually realted to a bad cable or connector.

OK, if this happens again I will try a new cable. However, the backplane
(it is this one:
http://www.raidsonic.de/en/pages/products/backplanes.php?we_objectID=4251 ) was working nicely with another disk in the same slot (but maybe I did not perfectly insert the disk...)

> ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> 
> Did you remove the 1.5 Gbps jumper so it can run at 3.0 Gbps?

Yes. This is actually the only difference to the drive before (which was
1.5 Gbps).

For now it is all running nicely and I did a full dd if= ... read of the
disk:

ata3: SATA max UDMA/133 irq_stat 0x00400040, connection status changed irq 510
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: HPA detected: current 2930277168, native 18446744072344861488
ata3.00: ATA-8: ST31500341AS, CC1G, max UDMA/133
ata3.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata3.00: configured for UDMA/133

Thank you very much!!
Soeren
