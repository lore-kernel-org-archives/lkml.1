Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbZK2PjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbZK2PjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 10:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbZK2PjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 10:39:22 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:46224 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZK2PjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 10:39:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SDCJu5PCKQW/pwd4VLERblEIJLaVZdeF3SfMWPKPTMNWm1ZfbZLHd5kVNmq3o29FUL
         6pGX32kj1Ak7EubSwjaw0WRNH5HUeNhmC+k2drkozgYbcR1quteBSyw/7km6QJErZFAM
         WZlrhUvlnanjnESvmu+HJIp3AipWF8nk1XfYg=
Message-ID: <4B1298B0.1050505@gmail.com>
Date: Sun, 29 Nov 2009 13:52:16 -0200
From: Bruno Barberi Gnecco <brunobg@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Michael Breuer <mbreuer@majjas.com>
CC: linux-kernel@vger.kernel.org, brunobg@gmail.com
Subject: Re: PROBLEM: BUG: Constant freezes and kernel panics on a quad core
 (with dumps)
References: <4B119D95.6090806@gmail.com> <4B119DD7.8020303@majjas.com>
In-Reply-To: <4B119DD7.8020303@majjas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd think this is a hardware problem. Some things that have caused me 
> similar grief in the past:

	It is possible, but I can rule most of them out. I think it's unlikely.

> Bad IDE cable
> Bad SATA cable

	Ruled out. Only SATA drives. I used two different HDs (separatedly) with different 
cables, and the live CD. It's not the cables or the drives.

> Bad power supply
> Bad motherboard

	Both are brand new, but of course that doesn't rule them out.

	Regarding the PS, I have checked voltages with a multimeter and they are more than fine, 
and the wattage is enough for the system, so it'd have to be a very weird transient glitch 
that affects only memory access. See also below.

	Any ideas to rule the MB out, other than "get a new one"?

> Bad memory (memtest doesn't necessarily access things the same way as 
> the kernel)

	Ruled out. I replaced with a 2GB DDR2, still got the bug: "BUG: Bad page map in process".

> Bad cards (pci, agp, whatever)

	Ruled out. The only card is the video card. I replaced it with a very old PCI board and 
still got error. This also pretty much rules out that the PS is underpowered, since I 
powered only the MB and the HD.

	Could it be one of the onboard things? I disabled everything but the LAN, and still got it.

> Any of the above with loose connections

	I already reconnected everything twice. Could still be a loose connection of one of the 
wires in the connector, but it's very very unlikely to give such a specific error on 
memory access.

> And did I mention bad power supply?

	Yes you did, and I'll try to get another one to be sure, but it could still be a software 
bug too.

	I tried to install an old Win2K I had here. It doesn't handle the big HD well and ends up 
not booting after installation (it can't partition it, also), but it didn't freeze (even 
though it formatted the disk and copied the files, which was not slow). So +1 to being a 
kernel bug.

	The most common error message I get is: "BUG: unable to handle kernel NULL pointer 
dereference."

	Any other suggestions? Any other information which could help?

	Thanks for the answer,

> Bruno Barberi Gnecco wrote:
>> Summary: a PC I'm testing is unstable and freezing often. Freezes 
>> occur in various situations, including under no load (not even the X 
>> running). Dumps are provided below.
>>
>> Sometimes it's a plain freeze, sometimes a kernel panic with the 
>> blinking leds and a dump. It seems the problem is related to memory, 
>> most of the messages are related to null memory references (see more 
>> below). System ran once for several hours before freezing.
>>
>> * System specification: Intel Core 2 Quad Q9550 @ 2.83GHz, 4GB DDR3, 
>> Motherboard Asus P5QC. No overclocking.
>>
>> * Tested under the following kernels/distros, all had the bug. Since I 
>> used their vanilla kernels, I'm not posting a copy of the .configs:
>>
>> - 2.6.27.7-smp (slackware 12.2 hugesmp kernel; distro heavily 
>> updated), 32 bits
>> - 2.6.29.6-smp (slackware 13.0 hugesmp kernel; fresh install), both 32 
>> and 64 bits
>> - 2.6.29.6-nosmp (slackware 13.0 huge kernel; fresh install), both 32 
>> and 64 bits
>> - 2.6.31-14-generic SMP (ubuntu 9.10 netbook remix live cd), 32 bits
>>
>> * Here are some screen dumps (sorry, no serial cable for a text dump).
>>
>> http://ultraxs.com/share-208E_4B118ED2.html
>> http://ultraxs.com/share-2FDD_4B118ED2.html
>> http://ultraxs.com/share-D0D9_4B118ED2.html
>> http://ultraxs.com/share-498F_4B118ED2.html
>> http://ultraxs.com/share-0AD8_4B118ED2.html
>>
>> * Turning off ACPI and APIC, either through the BIOS or through kernel 
>> parameters did not help, even when only one processor is recognized.
>>
>> * I ran memtest and no errors were detected. I completed the tests 
>> three times.
>>
>> * Nothing is ever output to the logs.
>>
>> * A sure way to get a freeze is to recompile the kernel, but the 
>> freeze does not happen at the same point of the compilation and I 
>> can't even say if the compilation triggers the bug or if it's just a 
>> coincidence and the compilation just takes long enough for it to happen.
>>
>> * Any other information, testing or debugging you need, just ask. I 
>> just can't use the PC, it usually freezes within minutes. Please CC 
>> any replies to me [brunobg at gmail]. Thank you very much for any help.
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


-- 
Bruno Barberi Gnecco <brunobg_at_users.sourceforge.net>

