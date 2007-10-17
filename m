Return-Path: <linux-kernel-owner+w=401wt.eu-S935808AbXJQALb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935808AbXJQALb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbXJQALY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:11:24 -0400
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:54102 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbXJQALX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:11:23 -0400
X-Greylist: delayed 2710 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2007 20:11:22 EDT
Message-ID: <471552B5.4080908@blueyonder.co.uk>
Date: Wed, 17 Oct 2007 01:09:25 +0100
From: Sid Boyce <g3vbv@blueyonder.co.uk>
Reply-To: g3vbv@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-git10 make  bzImage problem
References: <4715481F.7060502@blueyonder.co.uk>
In-Reply-To: <4715481F.7060502@blueyonder.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sid Boyce wrote:
> When booted, it complains that kernel size is too big, but size OK for a 
> bzImage, not for zImage as is returned by the file command, -git9 was 
> OK, x86_64 SMP kernel on two 64x2 boxes.
> I shall supplymy .config if needed, but they are the same as for -git9.
> 
>  # l arch/x86/boot/bzImage
> -rw-r--r-- 1 root root 1761496 2007-10-16 22:45 arch/x86/boot/bzImage
> 
> # file arch/x86_64/boot/bzImage
> arch/x86_64/boot/bzImage: symbolic link to 
> `/usr/src/linux-2.6.23-git10/arch/x86/boot/bzImage'
> 
> # file arch/x86/boot/bzImage
> arch/x86/boot/bzImage: Linux/x86 Kernel, Setup Version 0x206, zImage, 
> RO-rootFS, root_dev 0x801, swap_dev 0x1, Prompt for Videomode
> 
> Regards
> Sid.

Fixed by the following patch.
=============================
Signed-off-by: Eric W. Biederman <ebiederm@xxxxxxxxxxxx>
---
arch/x86/boot/Makefile | 6 +++---
1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index d6ed8e5..0e4912f 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -64,10 +64,10 @@ KBUILD_CFLAGS := $(LINUXINCLUDE) -g -Os -D_SETUP 
-D__KERNEL__ \
KBUILD_AFLAGS := $(KBUILD_CFLAGS) -D__ASSEMBLY__

$(obj)/zImage: IMAGE_OFFSET := 0x1000
-$(obj)/zImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK)
+$(obj)/zImage: asflags-y += $(SVGA_MODE) $(RAMDISK)
$(obj)/bzImage: IMAGE_OFFSET := 0x100000
-$(obj)/bzImage: EXTRA_CFLAGS := -D__BIG_KERNEL__
-$(obj)/bzImage: EXTRA_AFLAGS := $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
+$(obj)/bzImage: ccflags-y += -D__BIG_KERNEL__
+$(obj)/bzImage: asflags-y += $(SVGA_MODE) $(RAMDISK) -D__BIG_KERNEL__
$(obj)/bzImage: BUILDFLAGS := -b

quiet_cmd_image = BUILD $@

Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support 
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

