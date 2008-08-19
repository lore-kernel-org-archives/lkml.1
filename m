Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYHSSEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYHSSEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 14:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYHSSDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 14:03:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:20545 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbYHSSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 14:03:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=LjS+nMsLqyiF60r2RN6qoW7ByGQFOA0qAMk+hejEH4Ne5XJHRemWufS8FLelMu8Yr1
         TydnreGm8d9+FjQN5kwEaAyAjcUmGwrGQ1FMRjLDGTfxAjD9xjdf+sw9CUuVZ94p70Zu
         ZeU4OXhQbW04IjzOlY5w+nP4r65gD7hgqfgQ0=
To: Alex Riesen <raa.lkml@gmail.com>
Subject: Re: rt2500pci: rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
Date: Tue, 19 Aug 2008 20:03:44 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       rt2400-devel@lists.sourceforge.net
References: <20080819173524.GA4708@steel.home>
In-Reply-To: <20080819173524.GA4708@steel.home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808192003.45072.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> The rt2500 driver in 2.6.27-rc3 (v2.6.27-rc3-552-g3c3a15a) constantly
> produces a lot of this messages in log (slowdown quite noticable):
> 
>     kernel: phy0 -> rt2500pci_bbp_read: Error - BBPCSR register busy. Read failed.
>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.
>     last message repeated 40 times
>     kernel: phy0 -> rt2500pci_rf_write: Error - RFCSR register busy. Write failed.
>     last message repeated 7 times
>     kernel: phy0 -> rt2500pci_bbp_write: Error - BBPCSR register busy. Write failed.

This is a bad sign, the slowdown is expected since the driver is continuously looping
waiting for the registers to become available. Did this PCI card work in the past, and
if so with what driver?

Does this card work on another PC, or does the windows or legacy driver work with
this card?

(Yes, all suggestions above imply suspicion about the hardware itself rather then the driver)

Ivo

> The card is a RaLink RT2500 PCI (not mini-PCI, it is a normal desktop
> system, Gigabyte GA-8IPE1000 motherboard):
> 
>     02:04.0 Ethernet controller: RaLink RT2500 802.11g Cardbus/mini-PCI (rev 01)
> 	    Subsystem: Micro-Star International Co., Ltd. Unknown device 6834
> 	    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
> 	    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR+
> 	    Latency: 32, Cache Line Size: 32 bytes
> 	    Interrupt: pin A routed to IRQ 11
> 	    Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=8K]
> 	    Capabilities: [40] Power Management version 2
> 		    Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
> 		    Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> 
> The system is a P4 with HT enabled (and active). The .config is below:
