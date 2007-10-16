Return-Path: <linux-kernel-owner+w=401wt.eu-S935875AbXJPUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935875AbXJPUlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761517AbXJPUlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:41:04 -0400
Received: from rtr.ca ([76.10.145.34]:3873 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761578AbXJPUlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:41:01 -0400
Message-ID: <471521DC.5030007@rtr.ca>
Date: Tue, 16 Oct 2007 16:41:00 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: pcihpd-discuss@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: PCIe Hotplug:  NFG unless I boot with card already inserted.
References: <4714C0A6.1030204@rtr.ca>	<4714D700.7060008@rtr.ca>	<20071016084634.8a0d695a.kristen.c.accardi@intel.com>	<47150565.5090102@rtr.ca> <20071016132941.69d9050f.kristen.c.accardi@intel.com>
In-Reply-To: <20071016132941.69d9050f.kristen.c.accardi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
> On Tue, 16 Oct 2007 14:39:33 -0400
> Mark Lord <lkml@rtr.ca> wrote:
> 
>> Another thing:  if a card is already in the slot before pciehp is loaded
>> (under any circumstances), then pciehp does *not* see the card until I
>> unplug/replug it.


You mean that the existing code does not handle it properly.
The hardware can see the card just fine, as reflected in the slot
status bits.

> One other thing to note here, the proper operation of hot plug dictates that
> if you boot your laptop with no adapter in the slot, you must first load
> the driver in order for the new adapter interrupt to be captured.  So,
> if you insert a card without the driver loaded, it will not be enumerated
> by PCI until you remove it and the reinsert it.

Bull puckey.

If there's already a card in the slot when we turn on the power,
the Linux kernel should find and use that card.

This is flawed, and needs fixing.

Cheers
