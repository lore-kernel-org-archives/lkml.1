Return-Path: <linux-kernel-owner+w=401wt.eu-S1753211Ab0AGQZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab0AGQZn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 11:25:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828Ab0AGQZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 11:25:43 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:43429 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab0AGQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 11:25:42 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: Linux 2.6.33-rc3, rc2 regression at boot FIXED
Date: Thu, 07 Jan 2010 11:25:28 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3; KDE/4.3.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1001051838410.3630@localhost.localdomain>
 <201001061936.10315.gene.heskett@verizon.net>
 <201001071035.15048.gene.heskett@verizon.net>
In-reply-to: <201001071035.15048.gene.heskett@verizon.net>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Message-id: <201001071125.29070.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 January 2010, Gene Heskett wrote:
>On Wednesday 06 January 2010, Gene Heskett wrote:
>>On Wednesday 06 January 2010, Jiri Kosina wrote:
>>>On Wed, 6 Jan 2010, Gene Heskett wrote:
>>>> >[    0.558368] Unpacking initramfs...
>>>> >[    0.648644] Freeing initrd memory: 3431k freed
>>>> >[    0.651635] platform microcode: firmware: requesting
>>>> > amd-ucode/microcode_amd.bin [   60.646738] microcode: failed to load
>>>> > file amd-ucode/microcode_amd.bin [   60.646858] microcode: CPU0:
>>>> > patch_level=0x1000065
>>>> >[   60.646977] microcode: CPU1: patch_level=0x1000065
>>>> >[   60.647099] microcode: CPU2: patch_level=0x1000065
>>>> >[   60.647218] microcode: CPU3: patch_level=0x1000065
>>>> >
>>>> >Note the time, it kills quite close to a whole minute there, which at
>>>> > first would appear to be because there is not yet a mounted /lib
>>>> > filesystem to suck it from.  I didn't build an rc1, but rc2 also
>>>> > suffers from this. 2.6.32.2 does not do this although its firmware
>>>> > request takes place at the same point. So it doesn't look like it is
>>>> > the lack of a mounted filesystem after all.
>>>> >
>>>> >FWIW, because it was a hot reboot, the patch_level reported is the
>>>> > correct level.
>>>> >
>>>> >I am also seeing some complaints about my Audigy2 sound card, but what
>>>> > I saw during the boot, never made it to the messages log.  Something
>>>> > about guessing at the proper config, but I did hear kde sign on when
>>>> > x started.
>>>> >
>>>> >Thanks Linus.
>>>>
>>>> Update, I edited the .config by hand and added the full path in
>>>> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
>>>> which was just 'firmware', and rebuilt.  No difference.  I still get
>>>> the 60 second hang.  FWIW, this particular setting isn't visible in a
>>>> make xconfig.
>>>
>>>As this is already at the stage when userspace exists and init has been
>>>started, it might well be delay of some userspace stuff, not directly
>>>kernel.
>>>
>>>Does alt-sysrq-t at the time it is stuck give any clue?
>>
>>I will try that when I next reboot, thanks Jiri
>
>I just did, and ran into 2 things, 1st being an oops or crash that stopped
>the shutdown and I was forced to use the hdwe reset button.  I rebooted to
>2.6.32.3 which worked nominally correct, then to 2.6.33-rc3 again, and
> played 10,000 monkeys on the keyboard while it was sitting there waiting
> for the /lib/firmware/amd-ucode/micrococode_amd.bin for 60 seconds, with
> no apparent effect.
>
>I am not convinced my wireless keyboard is alive at 0.6 seconds into the
> boot procedure.  Or I was using the wrong key for 'sysreq' as susch a
> labeled key does not exist on this logitek cordless keyboard.
>
>What line in the .config file actually specifies the path it is supposed to
>be searching to find this file?
>
>>From a grep FIRM .config:
>
>CONFIG_PREVENT_FIRMWARE_BUILD is not set
>CONFIG_FIRMWARE_IN_KERNEL=y
>CONFIG_EXTRA_FIRMWARE="radeon/R100_cp.bin.ihex  radeon/R200_cp.bin.ihex
>radeon/R300_cp.bin.ihex  radeon/R420_cp.bin.ihex  radeon/R520_cp.bin.ihex
>radeon/RS600_cp.bin.ihex  radeon/RS690_cp.bin.ihex"
>CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
>CONFIG_LIBERTAS_THINFIRM=m
>CONFIG_LIBERTAS_THINFIRM_USB=m
>CONFIG_HOSTAP_FIRMWARE=y
>CONFIG_HOSTAP_FIRMWARE_NVRAM=y
>CONFIG_FIRMWARE_EDID=y
>CONFIG_FIRMWARE_MEMMAP=y
>
>Is something missing above?
>
>If I want to add the amd-ucode/microcode_amd.bin to CONFIG_EXTRA_FIRMWARE,
> I will have to do it by hand as the xconfig editing function for that line
> seems to have gone away.  That list of radeon stuff hasn't been touched in
> nearly 2 years.  However, I will do that and report eventually.
>
>Or did the firmware loader itself get broken?
>
>Thanks Jiri.

Update:  Fixed for me.

I left that line in the .config with the amd-ucode/microcode_amd.bin added as 
discussed above, but I finally grokked that the kernel trees firmware/amd-
ucode directory was not there, so I moved a copy of the microcode_amd.bin 
into that directory and re-ran my makeit script.  No errors during the make, 
and the 1 minute stall problem at .6 seconds into the boot is now fixed.

2 Silly Q's though:

1.  Can this file not be distributed as part of the kernel tarball?

2. Why did this Just Work(TM) for 2.6.32.3 and all previous kernels when the 
only copy on the system was in /lib/firmware/amd-ucode, but not for 2.6.33-
rcany so far?  FWIW, 2.6.32.3/firmware has no amd-ucode subdir at all!

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Anything is possible on paper.
		-- Ron McAfee
