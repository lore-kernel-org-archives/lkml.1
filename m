Return-Path: <linux-kernel-owner+w=401wt.eu-S1753121AbZIOLXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbZIOLXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 07:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbZIOLXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 07:23:48 -0400
Received: from mx2.compro.net ([216.54.166.4]:30371 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbZIOLXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 07:23:47 -0400
X-IronPort-AV: E=Sophos;i="4.44,389,1249272000"; 
   d="scan'208";a="4367359"
Message-ID: <4AAF7945.2030905@compro.net>
Date: Tue, 15 Sep 2009 07:23:49 -0400
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-pci@vger.kernel.org, Mark Hounschell <dmarkh@cfl.rr.com>,
       linux-kernel@vger.kernel.org
Subject: Re: problems doing direct dma from a pci device to pci-e device
References: <4AAA5B1F.3020103@compro.net> <20090911154714.70a94454@lxorguk.ukuu.org.uk>
In-Reply-To: <20090911154714.70a94454@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> I now have an AM3 based DFI DK 790FXB-M3H5 motherboard. This board has 3 regular
>> PCI slots and 3 PCI-E (16x) slots. I also have a PCI-E (x4) version of the VMIC-5565
>> reflective memory  card in one of the PCI-E slots and our gpiohsd card in one of the regular
>> PCI slots. All on the motherboard. No expansion slots being used. However I cannot get
>> data from our gpiohsd into the PCI-E VMIC-5565 cards memory. I can certainly get the data there
>> from a userland buffer, no problem. Just not from one card to the other directly. Oh and when
>> I put the regular PCI version of the VMIC into one of the regular PCI slots everything works
>> as expected. They are then both on the same PCI bus and no bridges are involved though.
> 
> Have you verified with the vendor that such DMA works properly ? There is
> a long history of there being boards where some device to device DMA
> exploded or vanished. The arrival of PCI capture cards doing direct to
> video DMA cleaned the world up (eg the BT848) but I wouldn't be suprised
> if this recurred somewhere since they were popular and nobody really
> noticed as they didn't run such an unusual config.
> 

I have now verified the the VMIC card does support this type of I/O. I dug up the MB I was
using during my original testing. It's has almost the same slot configuration but an nvidia chip
set as opposed to AMD. It does in fact work fine using that MB with the nvidia chip set. 
I have 3 different boards with AMD chip sets and none of them work. 
 
> Also does the board have a true IOMMU in the PCI-E side of the system ?
> It's not a chipset I know.
>

I'm not sure what you mean by "a true" IOMMU, afaict the IOMMU is now 
called "Virtualization Technology" or works in conjunction with it and almost 
any new MB has it. "Virtualization" can be enabled or disabled via a BIOS setting. 
So I assume when "Virtualization" is disabled that the IOMMU is disabled. Would
that be a correct assumption? And I also assume, from the AMD spec on it, that
when the IOMMU is disabled  addresses are passed unaltered through it? 
 
The MB I have in which all this works, works with the BIOS "Virtualization"
setting enabled or disabled. That was unexpected and I don't really understand that. 
Also the MBs that it doesn't work on, doesn't work with it enabled or disabled. 
So I am still at complete loss as to what is really happening.

I suppose the BIOS setting in each of the MBs could be broken. The one that
works is disabled even when enabled in the BIOS, and the one that doesn't work 
is enabled even when disabled in the BIOS?? Just a guess.

I guess with some time I might be able to figure out how to probe the IOMMU
off the bridges in question to see if they are on or off??

I was hoping the lspci data I sent would show something obvious to the experts
unrelated to the IOMMU.

Thanks again in advance for any additional pointers
Regards Mark
 


