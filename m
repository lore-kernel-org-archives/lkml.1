Return-Path: <linux-kernel-owner+w=401wt.eu-S1754026AbZIISSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbZIISSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbZIISSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:18:38 -0400
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:36365
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbZIISSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:18:38 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Sep 2009 14:18:37 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Au8AABuMp0rLO2ZB/2dsb2JhbAAI316EGAWBVGQ
X-IronPort-AV: E=Sophos;i="4.44,359,1249228800"; 
   d="scan'208";a="5061825"
Message-ID: <4AA7EF39.6060800@iinet.net.au>
Date: Thu, 10 Sep 2009 02:08:57 +0800
From: Shane Arnold <clontarf_x@iinet.net.au>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>, linux-kernel@vger.kernel.org
Subject: Re: Bringing up secondary rtl8169-based interface causes network
 hang/dma issues
References: <4AA6506A.7040900@iinet.net.au> <20090908175550.GA30098@electric-eye.fr.zoreil.com>
In-Reply-To: <20090908175550.GA30098@electric-eye.fr.zoreil.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well it seems I have solved it by disabling APIC and MSI/MSI-X 
interrupts. Both NIC's up and playing nicely.

Now just to figure out why it's not communicating with anything...

Thanks Francois!

Francois Romieu wrote:
> Shane Arnold <clontarf_x@iinet.net.au> :
> [...]
>> The issue I am having is when bringing up a second Ethernet interface  
>> that uses the rtl8169 driver, it seems to cause network issues. I lose  
>> all network connectivity to the machine, and I simultaneously see a DMA  
>> error occur for my primary IDE drive.
>>
>> Two interfaces:
>>
>> Quote:
>> eth0 (rtl8168 (using rtl8169 driver) - Onboard PCI-E Gigabit Ethernet)
>> eth1 (rtl8169 (using rtl8169 driver) - RTL8169 PCI Gigabit Ethernet)
>                        ^^^^^^^
> Do you mean the in-kernel r8169 driver or Realtek's one ?
> 
>> The chipset running the IDE drive that experiences the DMA crash is:
>>
>> Quote:
>> ATI Technologies Inc SB700/SB800 IDE Controller (atiixp)
>> Vitals:
>>
>> Debian 5.0.1 @ Kernel 2.6.30
>>
>> 00:00.0 Host bridge: Advanced Micro Devices [AMD] RS780 Host Bridge
>> 00:01.0 PCI bridge: ASUSTeK Computer Inc. Device 9602
>> 00:06.0 PCI bridge: Advanced Micro Devices [AMD] RS780 PCI to PCI bridge  
>> (PCIE port 2)
>> 00:11.0 SATA controller: ATI Technologies Inc SB700/SB800 SATA  
>> Controller [IDE mode]
>> 00:12.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0  
>> Controller
>> 00:12.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
>> 00:12.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
>> 00:13.0 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI0  
>> Controller
>> 00:13.1 USB Controller: ATI Technologies Inc SB700 USB OHCI1 Controller
>> 00:13.2 USB Controller: ATI Technologies Inc SB700/SB800 USB EHCI Controller
>> 00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 3a)
>> 00:14.1 IDE interface: ATI Technologies Inc SB700/SB800 IDE Controller
>> 00:14.3 ISA bridge: ATI Technologies Inc SB700/SB800 LPC host controller
>> 00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
>> 00:14.5 USB Controller: ATI Technologies Inc SB700/SB800 USB OHCI2  
>> Controller
>> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]  
>> HyperTransport Technology Configuration
>> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]  
>> Address Map
>> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]  
>> DRAM Controller
>> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron]  
>> Miscellaneous Control
>> 01:05.0 VGA compatible controller: ATI Technologies Inc Radeon HD 3200  
>> Graphics
>> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.  
>> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
>> 03:07.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
>> 03:07.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
>> 03:07.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
> 
> The second (PCI only ?) network card is plugged and lspci does not display
> it, right ?
> 
>> The output from kern.log is as follows (right after bringing the link up)
> 
> Please send a complete dmesg from boot and the content of /proc/interrupts
> once the link is brought up.
> 
> [...]
>> If you guys need any package versions just ask. Also feel free to point  
>> me in the direction of a better place to post this issue.
> 
> It is suggested to send network related problems to netdev@vger.kernel.org
> 


