Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYL3RuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYL3RuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYL3RuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:50:04 -0500
Received: from main.gmane.org ([80.91.229.2]:38426 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbYL3RuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:50:03 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Question with AHCI and (UDMA/100 vs. UDMA/133)
Date: Tue, 30 Dec 2008 11:34:15 -0600
Message-ID: <495A5B97.4040202@shaw.ca>
References: <alpine.DEB.1.10.0812300651190.11356@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <alpine.DEB.1.10.0812300651190.11356@p34.internal.lan>
Cc: linux-ide@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz wrote:
> Do some chipsets (SiI 3132 vs. Intel ICH9) run certain drives at 
> UDMA/100 vs. UDMA/133?

On native SATA drives and controllers, the UDMA speed really has no 
effect. At the low level there are just frames going back and forth on 
the link at either 1.5 or 3.0 Gbps so the UDMA speed doesn't really 
control anything. If there is a PATA bridge involved (either internal or 
external to the drive) then this can affect the speed on the PATA bus, 
but that won't be the case here (NCQ support wouldn't be possible in 
that case).

> 
> I have several 750GB WD drives (exact make/model) and the ones on the 
> intel chipset show up as:
> 
> [    1.407321] ata3.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max 
> UDMA/133
> [    1.407409] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth 
> 31/32)
> [    1.408300] ata3.00: configured for UDMA/133
> 
> The ones on the SiI 3132 chipset show up as:
> 
> [    9.604413] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
> [    9.619024] ata11.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max 
> UDMA/133
> [    9.619111] ata11.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 
> 31/32)
> [    9.620029] ata11.00: configured for UDMA/100
> 
> If they are both 3.0 Gbps, are they both the same speed even though one 
> is configured for a slower speed than the other?

Yes.

> 
> Or is it the case that the SiI 3132 does not support AHCI and that is 
> the reason for the difference?  Does it make any difference in performance?

3132 is not an AHCI controller but it still supports most or all of the 
same features. (AHCI is not a feature set, it's a particular hardware 
interface.)

> 
> SiI Controller:
> 02:00.0 RAID bus controller: Silicon Image, Inc. SiI 3132 Serial ATA 
> Raid II Controller (rev 01)
> 
> Intel Controller:
> 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 
> port SATA AHCI Controller (rev 02)
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

