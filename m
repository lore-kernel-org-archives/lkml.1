Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYBENGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYBENGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 08:06:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYBENGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 08:06:23 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:23251 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYBENGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 08:06:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=hCam7Do2sY3idLZWc1LKnvC5TenVxam9U6ReOCvrsZjiXBgBw2PJtXWpyXDQAdd0ACnJl7nIvs0Dt5oYEfURqC4C9bRr9NKNmLgPSom5c+rCFa/ntUMXfz35uqLfdVgDbgc63okkNA7ha39LROf8gO8O1EOlZ8PgoxCT19t/08s=
Date: Tue, 5 Feb 2008 14:06:22 +0100
To: "Mader, Alexander (N-MSR)" <Alexander.Mader@niles.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unable to access PCMCIA with O2 Micro OZ711MP1/MS1
Message-Id: <20080205140622.bf41f3ce.Kristoffer.ericson@gmail.com>
In-Reply-To: <47A7F828.1010303@niles.de>
References: <47A7F828.1010303@niles.de>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.5; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Feb 2008 06:46:16 +0100
"Mader, Alexander (N-MSR)" <Alexander.Mader@niles.de> wrote:

> Hello,
> 
> after contacting linux-pcmcia and some search I am approaching lkml.
> 
> There seems to be a problem accessing PCMCIA cards with O2 Micro 
> OZ711MP1/MS1 Controller.
> 
> On a Fujitsu Siemens Celsius H240 a 2.6.22-3-amd64 kernel from Debian 
> testing is in use. PCMCIA utilities for Linux 2.6 version 014-4 are 
> installed. I could supply the output of lspci and lshal.

Assuming debian has alot of patches applied, it would be interesting to see
if this bug exist on vanilla 2.6.24. Would probably get alot more attention from
pcmcia guru's.

> 
> When I insert a CardBus adapter, for instance a CNET CNF401 fast 
> ethernet, everything works fine and the adapter becomes available to the 
> system -- in this example the NIC with working LAN access. The lspci and 
> lshal output then reflects the new hardware.
> 
> When I insert a PCMCIA adapter, for instance a 3com 3CCE589EC, a 3com 
> 3C589C or an compact flash adapter, almost nothing happens: In the case 
> of the 3com I just get (dmesg):
> 
> 	pccard: PCMCIA card inserted into slot 0

So your issue is with non-cardbus pcmcia cards?

> 
> In the case of the compact flash adapter at the first insert dmesg gives:
> 
> pccard: PCMCIA card inserted into slot 0
> cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xfffff
> cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
> cs: memory probe 0x88000000-0x8fffffff: excluding 0x88000000-0x8fffffff
> cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
> cs: memory probe 0xf0300000-0xf03fffff: excluding 0xf0300000-0xf03fffff
> 
> Later on dmesg just issues "pccard: PCMCIA card inserted into slot 0" 
> when the same card is inserted no matter how often.
> 
> In the PCMCIA cases the lshal output doesn't change, but in the lspci 
> output the original line changes from:
> 
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+
> 	PostWrite+                                  ^^^^^^
> 

Have you looked inside the pcmcia driver file to check what sets the Reset +/-?


> to:
> 
> 	BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset- 16bInt+
> 	PostWrite+                                  ^^^^^^
> 
> In the case of the compact flash adapters neither "modprobe ide_cs" nor 
> "modprobe pata_pcmcia" yield anything -- not even in dmesg.
> 
> As I do not want to access a SmartCard I did not try the o2scr driver 
> from gna.org/projects/o2scr.
> 
> If I could supply more data I would like to do so on your request.
> 
> Best regards, Alexander.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
