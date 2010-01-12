Return-Path: <linux-kernel-owner+w=401wt.eu-S1754346Ab0ALAWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0ALAWp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 19:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358Ab0ALAWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 19:22:45 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:36415 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0ALAWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 19:22:43 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux 2.6.33-rc3, rc2 regression at boot FIXED
Date: Mon, 11 Jan 2010 19:22:18 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3; KDE/4.3.3; i686; ; )
Cc: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1001051838410.3630@localhost.localdomain>
 <201001071125.29070.gene.heskett@verizon.net> <4B4BB25D.7010507@tmr.com>
In-reply-to: <4B4BB25D.7010507@tmr.com>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-6
Content-transfer-encoding: 7bit
Message-id: <201001111922.18281.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 January 2010, Bill Davidsen wrote:
>Gene Heskett wrote:
>> On Thursday 07 January 2010, Gene Heskett wrote:
>>> On Wednesday 06 January 2010, Gene Heskett wrote:
>>>> On Wednesday 06 January 2010, Jiri Kosina wrote:
>>>>> On Wed, 6 Jan 2010, Gene Heskett wrote:
>>>>>>> [    0.558368] Unpacking initramfs...
>>>>>>> [    0.648644] Freeing initrd memory: 3431k freed
>>>>>>> [    0.651635] platform microcode: firmware: requesting
>>>>>>> amd-ucode/microcode_amd.bin [   60.646738] microcode: failed to load
>>>>>>> file amd-ucode/microcode_amd.bin [   60.646858] microcode: CPU0:
>>>>>>> patch_level=0x1000065
>>>>>>> [   60.646977] microcode: CPU1: patch_level=0x1000065
>>>>>>> [   60.647099] microcode: CPU2: patch_level=0x1000065
>>>>>>> [   60.647218] microcode: CPU3: patch_level=0x1000065
>>>>>>>
>>>>>>> Note the time, it kills quite close to a whole minute there, which
>>>>>>> at first would appear to be because there is not yet a mounted /lib
>>>>>>> filesystem to suck it from.  I didn't build an rc1, but rc2 also
>>>>>>> suffers from this. 2.6.32.2 does not do this although its firmware
>>>>>>> request takes place at the same point. So it doesn't look like it is
>>>>>>> the lack of a mounted filesystem after all.
>>>>>>>
>>>>>>> FWIW, because it was a hot reboot, the patch_level reported is the
>>>>>>> correct level.
>>>>>>>
>>>>>>> I am also seeing some complaints about my Audigy2 sound card, but
>>>>>>> what I saw during the boot, never made it to the messages log. 
>>>>>>> Something about guessing at the proper config, but I did hear kde
>>>>>>> sign on when x started.
>>>>>>>
>>>>>>> Thanks Linus.
>>>>>>
>>>>>> Update, I edited the .config by hand and added the full path in
>>>>>> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
>>>>>> which was just 'firmware', and rebuilt.  No difference.  I still get
>>>>>> the 60 second hang.  FWIW, this particular setting isn't visible in a
>>>>>> make xconfig.
>>>>>
>>>>> As this is already at the stage when userspace exists and init has
>>>>> been started, it might well be delay of some userspace stuff, not
>>>>> directly kernel.
>>>>>
>>>>> Does alt-sysrq-t at the time it is stuck give any clue?
>>>>
>>>> I will try that when I next reboot, thanks Jiri
>>>
>>> I just did, and ran into 2 things, 1st being an oops or crash that
>>> stopped the shutdown and I was forced to use the hdwe reset button.  I
>>> rebooted to 2.6.32.3 which worked nominally correct, then to 2.6.33-rc3
>>> again, and played 10,000 monkeys on the keyboard while it was sitting
>>> there waiting for the /lib/firmware/amd-ucode/micrococode_amd.bin for 60
>>> seconds, with no apparent effect.
>>>
>>> I am not convinced my wireless keyboard is alive at 0.6 seconds into the
>>> boot procedure.  Or I was using the wrong key for 'sysreq' as susch a
>>> labeled key does not exist on this logitek cordless keyboard.
>>>
>>> What line in the .config file actually specifies the path it is supposed
>>> to be searching to find this file?
>>>
>>> >From a grep FIRM .config:
>>>
>>> CONFIG_PREVENT_FIRMWARE_BUILD is not set
>>> CONFIG_FIRMWARE_IN_KERNEL=y
>>> CONFIG_EXTRA_FIRMWARE="radeon/R100_cp.bin.ihex  radeon/R200_cp.bin.ihex
>>> radeon/R300_cp.bin.ihex  radeon/R420_cp.bin.ihex 
>>> radeon/R520_cp.bin.ihex radeon/RS600_cp.bin.ihex 
>>> radeon/RS690_cp.bin.ihex"
>>> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
>>> CONFIG_LIBERTAS_THINFIRM=m
>>> CONFIG_LIBERTAS_THINFIRM_USB=m
>>> CONFIG_HOSTAP_FIRMWARE=y
>>> CONFIG_HOSTAP_FIRMWARE_NVRAM=y
>>> CONFIG_FIRMWARE_EDID=y
>>> CONFIG_FIRMWARE_MEMMAP=y
>>>
>>> Is something missing above?
>>>
>>> If I want to add the amd-ucode/microcode_amd.bin to
>>> CONFIG_EXTRA_FIRMWARE, I will have to do it by hand as the xconfig
>>> editing function for that line seems to have gone away.  That list of
>>> radeon stuff hasn't been touched in nearly 2 years.  However, I will do
>>> that and report eventually.
>>>
>>> Or did the firmware loader itself get broken?
>>>
>>> Thanks Jiri.
>>
>> Update:  Fixed for me.
>>
>> I left that line in the .config with the amd-ucode/microcode_amd.bin
>> added as discussed above, but I finally grokked that the kernel trees
>> firmware/amd- ucode directory was not there, so I moved a copy of the
>> microcode_amd.bin into that directory and re-ran my makeit script.  No
>> errors during the make, and the 1 minute stall problem at .6 seconds into
>> the boot is now fixed.
>>
>> 2 Silly Q's though:
>>
>> 1.  Can this file not be distributed as part of the kernel tarball?
>>
>> 2. Why did this Just Work(TM) for 2.6.32.3 and all previous kernels when
>> the only copy on the system was in /lib/firmware/amd-ucode, but not for
>> 2.6.33- rcany so far?  FWIW, 2.6.32.3/firmware has no amd-ucode subdir at
>> all!
>
>I spent some time looking at this, and on my systems the real root has been
>mounted before the system looks for the CPU microcode, so I really can't
> see why on yours it is asking early.
>
>Turning off my "quiet" boot option and egrepping for "dracut|firmware" I
> get the attached. Does your not show the switch (pviot root) before the
> CPU firmware?

I believe, since your snip has syslog timestamps, that you are looking at a 
considerably later event that obviously has to do with an ATI radeon video 
facility.  Those reports I see at about the 40 second point in my dmesg.

This lockup occurs at .64 to .65 seconds in the dmesg as displayed on the 
console (I never run 'quiet' here).

Perhaps I have what one could call a broken partitioning setup here, but when 
the original drive failed, and I copied everything I could get from the old 
one onto a freshly partitioned drive, partitioned to suit me, I now may have 
something mussed up, but the system is now at least 3x faster and has stayed 
that way compared to before the drive failure.  Here is my current 
partitioning for the physical drive containing this F10 install on a 
terrabyte drive:

/dev/sda3 on / type ext3 (rw)
/dev/sda1 on /boot type ext3 (rw)
/dev/sda5 on /opt type ext3 (rw)
/dev/sda6 on /home type ext3 (rw)
/dev/sda7 on /root type ext3 (rw)
/dev/sda8 on /var type ext3 (rw)
/dev/sda9 on /tmp type ext3 (rw)
/dev/sda10 on /usr type ext3 (rw)

/dev/sda2 is swap, which I always put at an outside, faster location on the 
drive _if_ the choice is mine.
 
Which is a far cry from the drive mapping and partition size limits that the 
fedora installer forces on the hapless user. 199 megs max for /boot? What ARE 
they smoking?

I have serious doubts that /dev/sda3, where /lib/firmware lives, has been 
mounted and is accessible .65 seconds after dmesg's timekeeping starts.
10+ seconds maybe, but .65 seconds?  Nuh uh.  The first mention of anything 
related to sata is:
[    0.685767] sata_nv 0000:00:05.0: version 3.5

A good .03 seconds after the microcode is found and applied in this sequence:

[    0.651404] platform microcode: firmware: using built-in firmware amd-
ucode/microcode_amd.bin
[    0.651623] microcode: CPU0: patch_level=0x1000065
[    0.651743] microcode: CPU1: patch_level=0x1000065
[    0.651866] microcode: CPU2: patch_level=0x1000065
[    0.651986] microcode: CPU3: patch_level=0x1000065
[    0.652139] microcode: Microcode Update Driver: v2.00 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba

Note it says using built in, if it is not built in, there is a 60 second hang 
there in post 2.6.32.3 kernels apparently because it can't find 
/lib/firmware.

But I'll repeat, kernels up to 2.6.32.2 at least, have no problems with that 
code module not being built into the kernel's bzImage, it finds it on the 
drive and applies it instantly at that same .65 seconds from starting the 
clock time to counting.

I have fixed my buildit26 script to copy that code module to the kernel trees 
own firmware tree, and have included it in the list of firmware in the 
.config file to be included in the kernel, although make xconfig is now 
broken for editing that and I have to do that by hand with vim.  But I 
believe it works as shown above.

When -rc4 is out, I'll comment those lines out of that script and test it, 
but I expect I'll have to un-comment them and rebuild the tree again.

No biggie to me, but its a niggle a new user might find as a good excuse to 
go back to (spit) vista.  So IMO it needs to be addressed, but I'm not _that_ 
good at code carving on these bigger machines at 75 yo , sorry.  My day was 
15-30 years ago on kit boards, color computers running os9 and amiga's.

I do play the canary in the coal mine reasonably well though, exactly the 
part I'm playing right now. ;-)

Thanks Bill & Jiri.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Perl has a long tradition of working around compilers.
             -- Larry Wall in <199708252256.PAA00105@wall.org>
