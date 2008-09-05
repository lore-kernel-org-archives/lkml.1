Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbYIENqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbYIENqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 09:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYIENqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 09:46:21 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:40331 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbYIENqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 09:46:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=T56VYVhJAMST0UFQSNHkLjnDq/2xL0jE/aactC+B4A9YiAVinFAIpxU86VrfP6xPk8
         G78gfkaialzP7DTb8QLwr6adfr5JYZEgs3DMOROSYWfcKPr3M3OZFc5O8IaHGY6oLdNs
         /pe4KrFKm5XHiBh3oF4brSGEtr75igBZWhOvM=
Message-ID: <48C13827.1010409@gmail.com>
Date: Fri, 05 Sep 2008 15:46:15 +0200
From: Anders Aagaard <aagaande@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080901)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: suspend-devel@lists.sourceforge.net
Subject: Re: [Suspend-devel] Resume performance
References: <48C10908.60101@gmail.com> <200809051308.14079.rjw@sisk.pl>
In-Reply-To: <200809051308.14079.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Friday, 5 of September 2008, Anders Aagaard wrote:
>> Hi
> 
> Hi,
> 
> This is a kernel problem, so let's CC the LKML.
> 
>> I have a intel P35 board with a quad core cpu in it, it's currently 
>> running as a server for a small network, and I'd like to be able to shut 
>> it down when idle, and use wake on lan to wake it up when it's needed. 
>> Now I got that part working quite well, but for some reason I have a 
>> long delay in resume.
>>
>> I seem to remember being able to resume this computer in 2-3 seconds 
>> when I was testing it, now it needs 35 seconds to resume.  It seems 
>> regardless of resume options used, and it always resumes to a working 
>> state without problems.
> 
> What kernel are you using at the moment and which one was used for the
> testing?

I'm using gentoo's 2.6.25-r7, I've also tried vanilla sources.

> 
>> I've tried quite a lot of things, booting with noapic/nosmp, booting a 
>> kernel without usb/network drivers, disabling ahci (using ata_piix 
>> driver instead of ahci), and there's always that one long delay.  And 
>> I'm not quite sure how the kernel printk timing information works, so 
>> I'm not sure whats causing that delay.
>>
>> Output from dmesg when booting with nosmp (to get accurate timing data):
>> scripts/show_delta -b "Force enabled HPET at resume"
>> [349.821150 < 7.039261 >] ata3.00: configured for UDMA/133
>> [349.821160 < 7.039271 >] sd 2:0:0:0: [sdc] 976773168 512-byte hardware 
>> sectors (500108 MB)
>> [349.821165 < 7.039276 >] sd 2:0:0:0: [sdc] Write Protect is off
>> [349.821166 < 7.039277 >] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
>> [349.821173 < 7.039284 >] sd 2:0:0:0: [sdc] Write cache: enabled, read 
>> cache: enabled, doesn't support DPO or FUA
>> [349.972801 < 7.190912 >] ata1: SATA link up 3.0 Gbps (SStatus 123 
>> SControl 300)
>> [349.979060 < 7.197171 >] ata1.00: configured for UDMA/133
>> [349.979070 < 7.197181 >] sd 0:0:0:0: [sda] 976771055 512-byte hardware 
>> sectors (500107 MB)
>> [349.979075 < 7.197186 >] sd 0:0:0:0: [sda] Write Protect is off
>> [349.979076 < 7.197187 >] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
>> [349.979083 < 7.197194 >] sd 0:0:0:0: [sda] Write cache: enabled, read 
>> cache: enabled, doesn't support DPO or FUA
> 
> It looks like this happens here.  Can you try to unload the network driver
> before suspend, please?

I tried to build a kernel without it, and it still takes the exact same 
amount to boot, I've also tried unloading usb drivers and it takes the 
exact same amount of time.

> 
>> [373.945179 < 31.163290 >] r8169: eth0: link up
>> [373.952159 < 31.170270 >] PM: Writing back config space on device 
>> 0000:02:02.0 at offset f (was 4020100, writing 4020104)
>> [373.952172 < 31.170283 >] PM: Writing back config space on device 
>> 0000:02:02.0 at offset 5 (was 0, writing fddf8000)
>> [373.952176 < 31.170287 >] PM: Writing back config space on device 
>> 0000:02:02.0 at offset 4 (was 0, writing fddfd000)
>> [373.952180 < 31.170291 >] PM: Writing back config space on device 
>> 0000:02:02.0 at offset 3 (was 0, writing 4410)
>> [373.952185 < 31.170296 >] PM: Writing back config space on device 
>> 0000:02:02.0 at offset 1 (was 2100000, writing 2100006)
>>
>> Notice the long delay between all hd's found and it writing back config 
>> space, note that this happens with or without that network card driver 
>> in the kernel.
>>
>> Attaching full log of boot + suspend/resume cycle, kernel booted with 
>> nosmp/noapic, it takes the same amount of time without those options, 
>> but timing data gets a bit garbled.
>>
>> Thanks for your work so far, it's working quite well and saving me a lot 
>> of power doing it this way, at this point I'm just trying to get it 
>> faster :)
> 
> Sure, 35 seconds to resume is hardly acceptable.
> 
> Thanks,
> Rafael
> 

