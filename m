Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752605AbYLRRdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYLRRdW (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 12:33:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751041AbYLRRdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 12:33:11 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:49153 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbYLRRdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 12:33:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent:from;
        b=IRclIb4DK8xDFUEVNo8CS6/q0mPxVWDvJU5rJnolDvpo364aCPqPzlSZyaK1GdZrt0
         6HKeZrzAmquVsQJPVZ1BF6QwCaeJ2cVbAcYMBppNmN48mN4zkRp0tEzJcmL14beJ+N+I
         60PcVCm3NuXS2O05MWMtQTFEMleqNzXRde/lI=
Date: Thu, 18 Dec 2008 18:35:06 +0100
To: Ingo Molnar <mingo@elte.hu>
Cc: Huang Ying <ying.huang@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change
Message-ID: <20081218173506.GA29781@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 37a92bc970ce025d8a42fed27413485fd341db31 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Thu, 18 Dec 2008 18:03:20 +0100
Subject: [PATCH] x86: revert CONFIG_RELOCATABLE=y defconfig change

This commit:

commit 5cb04df8d3f03e37a19f2502591a84156be71772
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun May 4 19:49:04 2008 +0200

   x86: defconfig updates

changed CONFIG_RELOCATABLE from n to y, which may lead to a mismatch
between the vmlinux debug information and the runtime location of the
kernel, even when the bootloader does not relocate the kernel.

Revert the specific change. Works for me with GRUB and qemu.

Reference: http://lkml.org/lkml/2008/11/25/243

Cc: Huang Ying <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/configs/i386_defconfig   |    2 +-
 arch/x86/configs/x86_64_defconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index 13b8c86..488cafc 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -298,7 +298,7 @@ CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
 # CONFIG_KEXEC_JUMP is not set
 CONFIG_PHYSICAL_START=0x1000000
-CONFIG_RELOCATABLE=y
+# CONFIG_RELOCATABLE is not set
 CONFIG_PHYSICAL_ALIGN=0x200000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index f0a03d7..4327bba 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -298,7 +298,7 @@ CONFIG_SCHED_HRTICK=y
 CONFIG_KEXEC=y
 CONFIG_CRASH_DUMP=y
 CONFIG_PHYSICAL_START=0x1000000
-CONFIG_RELOCATABLE=y
+# CONFIG_RELOCATABLE is not set
 CONFIG_PHYSICAL_ALIGN=0x200000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
-- 
1.5.6.5

