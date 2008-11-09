Return-Path: <linux-kernel-owner+w=401wt.eu-S1753527AbYKIAwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527AbYKIAwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 19:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYKIAwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 19:52:19 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:54843 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbYKIAwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 19:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aUa55N+f9ln3EIbon4wvcj+FcWEwUyaaLdcwZO64MjzoEnJ1Iky9A0VDrMAxB/9HFa
         wlk4EbuzhI1l04HKELj5zzCAHXpRlKfLLs2QUHFeZzBg2aG/MeEaIn755b/W3xUgssxk
         Ms4pd6pWMu8zLrK0ubbwd7OY3W7/QomTbgppk=
Message-ID: <49163435.20301@gmail.com>
Date: Sun, 09 Nov 2008 02:52:05 +0200
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
Yes, this almost fixes all issues with that.
Almost because, it looks like the EC changes screen brightness on his own when battery is plugged/unplugged,
but so does the gnome-power-manager, and thus it still hangs as before on battery removal (but doesn't hang otherwise)
I disabled that behaver in gnome-power-manager and now no more hangs.

I see that this fix fixes the polled mode. Any chance to make irq mode work?



>> ** 2 - wireless: not to mention the fact that ath5k wasn't installed by default in ubuntu...
>> wireless more or less works, but kernel log is full of backtraces.
> 
> Well, that doesn't tell us much.  Did they still happen after upgrading to 2.6.28-rc3?  Can we see them?
Fixed completely, looking through the git log I have seen a commit that fixes exactly same backtrace I had.
No more errors in kernel log.


> 
>> Was able to connect to my WPA2 access point.
>> Sometimes wireless fails completely, especially after suspend to ram.
>> Advanced features like monitor/injection work, but when I changed the card's
>> mac address it stopped working.
>> I also noticed that if I then start airodump, then wireless works with new mac.
This still not fixed, I ask about this again in separate mail.
>>
>>
>>
>> ** 3 - internal mic doesn't work.
>> tried model=acer, model=auto.
>> Overall it seems that alsa misprograms O/B realteck
>> codec.
>> I talk about this later.
Surprisingly, this is almost fixed.
I can record from both internal mic and external mic
(Quality is not so good, but is the same as in windows)

Almost, is that to increase capture level, I have to set "one" channel of it.
Eg: if I set 100% left and 100% right then capture level is very low.
But when I set 100% left and 0% right or vice versa it works fine.

Also the "mic boost" doesn't change capture volume for internal mic.
also the "mic boost" if set to high value works like analog loopback
(I hear what I say in mic in headphones, same happens on my main notebook acer 5720)


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
I am aware of this, but don't yet have a SD card to test.


>  
>> ** 7 - opengl is broken, I tried running neverball in fullscreen, but it shows wrong/corrupted
>> textures (compiz is running, and working well thought)
Without compiz neveball works fine (slow, but this is very slow hardware)

>>  
>> Now I installed 2.6.28-rc3 (actually latest -git)
>>
>>
>> Sadly nothing improved.
>> I only found few regressions:
>>
>>
>>
>> * Wireless now drops connection from my WPA2 access point after few minutes.
>> I changed temporarily its wireless protection to WEP and open mode, and both work
>> fine, maybe this is related to periodic key exchange WPA does?
Now fixed, big thanks.

>>
>> * System doesn't reboot/shutdown, just hangs.
> 
> Could be this:
> 
> <http://bugzilla.kernel.org/show_bug.cgi?id=11942>
> 
> As a fix, 8fd145917fb62368a9b80db59562c20576238f5a was reverted from the acpi tree.  This has also been submitted to mainline.
Also fixed big thanks.




Also noticed another bug:


If I suspend/resume with compiz running, on resume I see wallpaper and mouse cursor, everything hangs for 
minute or two, and sometimes forever.

2.6.27 worked fine.




Also hibernate doesn't work on my main notebook, but it is probably fixed, I update kernel to really latest -git
and tell you.


Big thanks for bugfixes, you saved me a lot of work and bisecting.

Biggest solvable problem now is sound support now I think, datasheets are there, and
I take a look at them.


Best regards,
	Maxim Levitsky



