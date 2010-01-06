Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302Ab0AFVDB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab0AFVDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 16:03:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755997Ab0AFVC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 16:02:59 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:20769 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab0AFVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 16:02:58 -0500
From: Gene Heskett <gene.heskett@verizon.net>
Organization: Organization? Not detectable
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 2.6.33-rc3, rc2 regression at boot
Date: Wed, 06 Jan 2010 16:02:44 -0500
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3; KDE/4.3.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.1001051838410.3630@localhost.localdomain>
 <201001052355.29640.gene.heskett@verizon.net>
In-reply-to: <201001052355.29640.gene.heskett@verizon.net>
MIME-version: 1.0
Content-type: Text/Plain; charset=iso-8859-15
Content-transfer-encoding: 7bit
Message-id: <201001061602.44133.gene.heskett@verizon.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Gene Heskett wrote:

Ping?

>On Tuesday 05 January 2010, Linus Torvalds wrote:
>>It's been quiet due to the holidays, so -rc3 is reasonably small despite
>>being a few days over the normal one-week mark. And most of the changes
>>are pretty trivial, although both ext4 and reiserfs had some trouble in
>>-rc2, hopefully all fixed now.
>>
>>The bulk of the patches are some SH defconfig updates (40%), but ignoring
>>those we have the normal "half drivers, half everything else" pattern. On
>>the driver front, the perhaps most notable change is not so much a code
>>change, but the small change of marking the "new" firewire stack as being
>>the recommended one.
>>
>>Wireless drivers, regular network drivers, filesystems, input layer..
>>
>>And here's to hoping one reason it's been quiet is that it's actually been
>>fairly stable. Give it a try,
>>
>>		Linus
>
>[...]
>
>I didn't see anything here, but on looking at the ChangeLog for rc1, I see
> a lot of stuff fiddling with firmware.  On my phenom x4, I get this very
> early in the boot:
>[    0.558368] Unpacking initramfs...
>[    0.648644] Freeing initrd memory: 3431k freed
>[    0.651635] platform microcode: firmware: requesting
> amd-ucode/microcode_amd.bin [   60.646738] microcode: failed to load file
> amd-ucode/microcode_amd.bin [   60.646858] microcode: CPU0:
> patch_level=0x1000065
>[   60.646977] microcode: CPU1: patch_level=0x1000065
>[   60.647099] microcode: CPU2: patch_level=0x1000065
>[   60.647218] microcode: CPU3: patch_level=0x1000065
>
>Note the time, it kills quite close to a whole minute there, which at first
>would appear to be because there is not yet a mounted /lib filesystem to
> suck it from.  I didn't build an rc1, but rc2 also suffers from this.
> 2.6.32.2 does not do this although its firmware request takes place at the
> same point. So it doesn't look like it is the lack of a mounted filesystem
> after all.
>
>FWIW, because it was a hot reboot, the patch_level reported is the correct
>level.
>
>I am also seeing some complaints about my Audigy2 sound card, but what I
> saw during the boot, never made it to the messages log.  Something about
> guessing at the proper config, but I did hear kde sign on when x started.
>
>Thanks Linus.
>
Update, I edited the .config by hand and added the full path in
CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware/"
which was just 'firmware', and rebuilt.  No difference.  I still get the 60 
second hang.  FWIW, this particular setting isn't visible in a make xconfig.

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)

Far duller than a serpent's tooth it is to spend a quiet youth.
