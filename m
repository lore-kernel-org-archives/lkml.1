Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYL3Vqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYL3Vqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 16:46:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYL3Vq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 16:46:26 -0500
Received: from mail.lang.hm ([64.81.33.126]:33264 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbYL3VqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 16:46:25 -0500
Date: Tue, 30 Dec 2008 14:48:30 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: early exception error
In-Reply-To: <20081230214143.GB11696@localhost>
Message-ID: <alpine.DEB.1.10.0812301446150.16936@asgard.lang.hm>
References: <alpine.DEB.1.10.0812301416550.16847@asgard.lang.hm> <20081230212645.GA11696@localhost> <alpine.DEB.1.10.0812301430390.16847@asgard.lang.hm> <20081230214143.GB11696@localhost>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:

> [david@lang.hm - Tue, Dec 30, 2008 at 02:31:28PM -0800]
>> On Wed, 31 Dec 2008, Cyrill Gorcunov wrote:
>>
>>> [david@lang.hm - Tue, Dec 30, 2008 at 02:21:10PM -0800]
>>>> I'm trying to upgrade a older dual opteron box to a current 64 bit
>>>> system, but I'm getting early exception errors from several different
>>>> kernels
>>>>
>>>> I tried the ubuntu 8.04 and 8.10 disks, and then I decided to try hunting
>>>> it down myself, so I took my 2.6.25 32 bit config copied it to a 64 bit
>>>> system and did a make oldconfig with 2.6.28 and am getting the same type
>>>> of error (the address changes from kernel to kernel and config to config
>>>> on the same kernel)
>>>>
>>>> doing a grep through System.map for the address that appears in the error
>>>> returns nothing
>>>>
>>>> attached are snapshots of the screen when the error happens and two
>>>> different configs with the same error (I tried disabling high-res timers,
>>>> tickless operation, and PAT, but got the same error), the 28 image is the
>>>> -2 config.
>>>>
>>>> where do I go from here to track this down?
>>>>
>>>> David Lang
>>> ...
>>>
>>> Hi David,
>>>
>>> not sure if it's the same but I've got similar errors for
>>> early_params being not capable to handle null passed args.
>>> What is the cmdline? It seems to be framebuffer related.
>>> But otoh I could be just wrong.
>>
>> very trivial
>>
>> grep -v "^#" /etc/lilo.conf
>> boot = /dev/sda
>> message = /boot/boot_message.txt
>> prompt
>> compact
>> timeout = 1200
>> change-rules
>>   reset
>> vga = ask
>> image = /boot/vmlinuz-2.6.28-64-2
>>   root = /dev/sda2
>>   label = 2.6.28-64
>>
>> I trimmed the additional boot images from this.
>>
>> David Lang
>>
>
> thanks David, will try to reproduce it

I disabled the framebuffer and still got the error

the system is a dual opteron 240 with an adaptec 3210S i2o raid card and 
radon video card

lspci returns

00:06.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8111 PCI (rev 07)
00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-8111 LPC (rev 05)
00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-8111 IDE (rev 03)
00:07.2 SMBus: Advanced Micro Devices [AMD] AMD-8111 SMBus 2.0 (rev 02)
00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-8111 ACPI (rev 05)
00:0a.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
00:0a.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:0b.0 PCI bridge: Advanced Micro Devices [AMD] AMD-8131 PCI-X Bridge (rev 12)
00:0b.1 PIC: Advanced Micro Devices [AMD] AMD-8131 PCI-X IOAPIC (rev 01)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
00:19.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:19.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:19.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:19.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:01.0 PCI bridge: PLX Technology, Inc.: Unknown device 8111 (rev 21)
01:03.0 PCI bridge: Adaptec (formerly DPT) PCI Bridge (rev 01)
01:03.1 I2O: Adaptec (formerly DPT) SmartRAID V Controller (rev 01)
03:00.0 VGA compatible controller: ATI Technologies Inc: Unknown device 7183
03:00.1 Display controller: ATI Technologies Inc: Unknown device 71a3
04:09.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 03)
04:09.1 Ethernet controller: Broadcom Corporation NetXtreme BCM5704 Gigabit Ethernet (rev 03)
05:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
05:00.1 USB Controller: Advanced Micro Devices [AMD] AMD-8111 USB (rev 0b)
05:08.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] (rev 10)

