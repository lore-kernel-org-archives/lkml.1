Return-Path: <linux-kernel-owner+w=401wt.eu-S1755746AbYKNTG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746AbYKNTG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 14:06:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbYKNTGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 14:06:18 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:10377 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYKNTGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 14:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=H7FkMjnbpgD3DFf0JYq5adsOXu7/SiEauiDdLQyD5MFSm+/B7KtnjUulC2/mLtqbhj
         KD6oo103/leGZQ5lZAvALh+YieOi21IeTh10RER1unNn3w7eZEFBLjCifFZJoc2adEtY
         vGr8KVqFdWY0mDHjX8y0EB0aCrgB/rX4vgp/Y=
Message-ID: <491DCC21.6060705@gmail.com>
Date: Fri, 14 Nov 2008 21:06:09 +0200
From: Maxim Levitsky <maximlevitsky@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       ath5k-devel@venema.h4ckr.net, alsa-devel@alsa-project.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: Bugs on aspire one A150
References: <491506DB.1070000@gmail.com> <49157E97.60503@tuffmail.co.uk>
In-Reply-To: <49157E97.60503@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Maxim Levitsky wrote:
>> I have just bought an Aspire one A150, XP version,
>> as it was the only available here, and installed ubuntu on it.
>>
>> Bugs I discovered so far:
>>
>>
>> ** 1 - embedded controler works in polling mode, due to this:
>>
>> [    0.708571] ACPI: EC: non-query interrupt received, switching to interrupt mode
>> [    1.224043] ACPI: EC: missing confirmations, switch off interrupt mode.
>>
>>
>> Maybe this is the reason for the fact that gnome power manager freezes when I unplug
>> the AC, and freezes often when I try to see battery status.
>>
>>
>> (Note: same is seen on my acer aspire 5720)
> 
> That sounds like a known issue.  It has been resolved by "ACPI: EC: revert msleep patch".  Happily Len submitted it for mainline this week.  You will also find it if you try the acpi-test git tree.  We're all hoping 2.6.28 will be much improved in terms of reliable operation of different ECs :).
> 
>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by default in ubuntu...
>> wireless more or less works, but kernel log is full of backtraces.
> 
> Well, that doesn't tell us much.  Did they still happen after upgrading to 2.6.28-rc3?  Can we see them?
> 
>> Was able to connect to my WPA2 access point.
>> Sometimes wireless fails completely, especially after suspend to ram.
>> Advanced features like monitor/injection work, but when I changed the card's
>> mac address it stopped working.
>> I also noticed that if I then start airodump, then wireless works with new mac.
>>
>>
>>
>> ** 3 - internal mic doesn't work.
>> tried model=acer, model=auto.
>> Overall it seems that alsa misprograms O/B realteck
>> codec.
>> I talk about this later.
>> Have same issue on my acer 5720
>>
>>
>>
>> ** 4 - wireless led doesn't work.
>> ath5k devs, can you fix this?
>>
>>
>> ** 5 - coretemp doesn't show cpu temperature,
>> I have seen somewhere that atom support same thermal diode as core2
>> and only patch to detect it is needed.
>> Please include such path in 2.6.28 if exists.
Patch for that does exits, but doesn't apply to latest git,
I will apply in manually.
This should go to .28 I think, this is trivial thing.


>>
>>
>> ** 6 - both card readers are missing from lspci, is this normal?
> 
> A similar bug has been reported as a regression:
> 
> <http://bugzilla.kernel.org/show_bug.cgi?id=11828>
> 
> so one assumes that it worked on the machines with linux pre-installed.  Hopefully without requiring any hacks.
> 
> It seems that for now a workaround may be to pass the option debug_quirks=1 to the sdhci module...
> 
> <http://marc.info/?l=linux-kernel&m=122509648027303&w=2>
> 
> ...or that it may help if you insert an SD card before booting.
> 
> Apparently the reporter also investigated pcie hotplug.  Probably the BIOS doesn't provide the normal support.  You can try "modprobe pciehp pciehp_force=1", maybe it helps the kernel discover the devices.  It worked for something else on my EeePC.  But then it will reportedly disappear the ethernet controller.
> 
> However, at the moment pciehp can cause delays of 10s of seconds during resume.
Got, a SD card, and with help of pciehp it works almost perfectly in both slots.
Almost, due to the fact that R/O switch is ignored.
(Just as I expected, a s/w switch, couldn't they think more, and include a hardware switch?)
On my main acer R/O switch works.

However I have to use pciehp_force=1, I understand that probably acpi tables are broken,
but could you add a workaround (dmi quirk?)

Also, there is a acpiphp driver, which doesn't work here.
pciehp is supposed to support so called native mode, don't yet know what it is,
but here it still uses acpi.


>  
>> ** 7 - opengl is broken, I tried running neverball in fullscreen, but it shows wrong/corrupted
>> textures (compiz is running, and working well thought)
I almost sure why this happens, opengl application is out of textures,
I need to install gem enabled intel driver here, and see how it works.



Best regards,
	Maxim Levitsky
