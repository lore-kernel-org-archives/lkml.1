Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYGQKqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYGQKqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 06:46:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbYGQKpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 06:45:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38259 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbYGQKpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 06:45:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=a7URZnwAAo8/pVpk5ZlyQuiAIEcmA24IO5uMv9Zc2lVfR3M78ERJN8Cpjr5gw/8SmJ
         wnjfbL4JXIWq0zOsXTE2mGzujJwWs3pkUaxT/H4jL8ch+CuKGjFeYUD3ucwBUiudbaPG
         zkBbhl3D9r9FYTcO/k+apU3RGzCVSjfqA4tbc=
Message-ID: <487F309D.20709@gmail.com>
Date: Thu, 17 Jul 2008 11:44:29 +0000
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080614)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807171232.46542.trenn@suse.de>
In-Reply-To: <200807171232.46542.trenn@suse.de>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> On Wednesday 16 July 2008 21:03:12 Thomas Gleixner wrote:
>   
>> On Wed, 16 Jul 2008, Thomas Renninger wrote:
>>     
> ...
>   
>> We definitely do not add x86 quirks into the generic code.
>>
>> Is there really no other way to fix this problem ? Which chipset is
>> involved here ? SB400/600 perhaps ?
>>     
>
> Evgeny's (eumaster) and Uli's chipsets are both:
>
> north-bridge: nvidia c51mv
> south-bridge: nvidia mcp51m
>
> Also both are MSI laptops:
>   - MSI-M670, modell MS-1632
>   - MSI S430x
> (This could also be a chipset or even an MSI specific BIOS bug?
> Richard could you compare with your HW, pls if still possible).
>
> Some more info:
>   - things break entering C2 or deeper
>   - noapictimer workaround helps to come a bit further, but results in sever
>     other errors, disk(dma error), keyboad, mouse etc., also see:
>     https://bugzilla.novell.com/show_bug.cgi?id=396220#c13
>   - "nohz=off" works (tested on 2.6.25.4-8-pae and 2.6.22.17-0.1-default SUSE kernels)
>   - processor.max_cstate=1 works
>
>        Thomas
>
> lspci
> 00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
> 00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
> 00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
> 00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)
> 00:00.4 RAM memory: nVidia Corporation C51 Memory Controller 4 (rev a2)
> 00:00.5 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
> 00:00.6 RAM memory: nVidia Corporation C51 Memory Controller 3 (rev a2)
> 00:00.7 RAM memory: nVidia Corporation C51 Memory Controller 2 (rev a2)
> 00:03.0 PCI bridge: nVidia Corporation C51 PCI Express Bridge (rev a1)
> 00:05.0 VGA compatible controller: nVidia Corporation MCP51 PCI-X GeForce Go 6100 (rev a2)
> 00:09.0 RAM memory: nVidia Corporation MCP51 Host Bridge (rev a2)
> 00:0a.0 ISA bridge: nVidia Corporation MCP51 LPC Bridge (rev a3)
> 00:0a.1 SMBus: nVidia Corporation MCP51 SMBus (rev a3)
> 00:0a.3 Co-processor: nVidia Corporation MCP51 PMU (rev a3)
> 00:0b.0 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
> 00:0b.1 USB Controller: nVidia Corporation MCP51 USB Controller (rev a3)
> 00:0d.0 IDE interface: nVidia Corporation MCP51 IDE (rev a1)
> 00:0e.0 IDE interface: nVidia Corporation MCP51 Serial ATA Controller (rev a1)
> 00:10.0 PCI bridge: nVidia Corporation MCP51 PCI Bridge (rev a2)
> 00:10.1 Audio device: nVidia Corporation MCP51 High Definition Audio (rev a2)
> 00:14.0 Bridge: nVidia Corporation MCP51 Ethernet Controller (rev a3)
> 00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
> 00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
> 00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
> 00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
>
>   
Hi All,

Here is a dump from lspci.... looks completely different :-P and here i 
was blaming ATI :-)

Richard


00:00.0 Host bridge: ATI Technologies Inc RS690 Host Bridge
00:01.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge 
(Internal gfx)
00:04.0 PCI bridge: ATI Technologies Inc Unknown device 7914
00:05.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI 
Express Port 1)
00:06.0 PCI bridge: ATI Technologies Inc RS690 PCI to PCI Bridge (PCI 
Express Port 2)
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SBx00 SMBus Controller (rev 14)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SBx00 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SBx00 PCI to PCI Bridge
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:05.0 VGA compatible controller: ATI Technologies Inc RS690M [Radeon 
X1200 Series]
02:04.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev b6)
02:04.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller 
(rev 02)
10:00.0 Ethernet controller: Broadcom Corporation NetLink BCM5787M 
Gigabit Ethernet PCI Express (rev 02)
30:00.0 Network controller: Broadcom Corporation BCM4312 802.11a/b/g 
(rev 02)



