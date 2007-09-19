Return-Path: <linux-kernel-owner+w=401wt.eu-S1761400AbXISQIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761400AbXISQIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 12:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbXISQIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 12:08:36 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:44852 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbXISQIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 12:08:35 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 19 Sep 2007 12:06:44 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH] ARM:  Drop support for redundant "keepinitrd" boot-time
 param.
Message-ID: <Pine.LNX.4.64.0709191203460.30041@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Given the equivalent "retain_initrd" boot-time paramater, "keepinitrd"
appears to be entirely superfluous.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  since this appears to be exactly the situation as with AVR32, it's
an equivalent patch.  there are no other situations like this in the
tree, but the decision is clearly up to the ARM folks.

  not compile tested.


 Documentation/kernel-parameters.txt   |    2 --
 arch/arm/configs/jornada720_defconfig |    2 +-
 arch/arm/mm/init.c                    |   12 +-----------
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 586b6f8..ccd3b1d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -847,8 +847,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			that the amount of memory usable for all allocations
 			is not too small.

-	keepinitrd	[HW,ARM]
-
 	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
 			in oops dumps.

diff --git a/arch/arm/configs/jornada720_defconfig b/arch/arm/configs/jornada720_defconfig
index 0c55628..e6c45a0 100644
--- a/arch/arm/configs/jornada720_defconfig
+++ b/arch/arm/configs/jornada720_defconfig
@@ -151,7 +151,7 @@ CONFIG_ALIGNMENT_TRAP=y
 #
 CONFIG_ZBOOT_ROM_TEXT=0x0
 CONFIG_ZBOOT_ROM_BSS=0x0
-CONFIG_CMDLINE="keepinitrd mem=32M"
+CONFIG_CMDLINE="retain_initrd mem=32M"
 # CONFIG_XIP_KERNEL is not set

 #
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c0ad7c0..440caa4 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -487,19 +487,9 @@ void free_initmem(void)

 #ifdef CONFIG_BLK_DEV_INITRD

-static int keep_initrd;
-
 void free_initrd_mem(unsigned long start, unsigned long end)
 {
-	if (!keep_initrd)
-		free_area(start, end, "initrd");
-}
-
-static int __init keepinitrd_setup(char *__unused)
-{
-	keep_initrd = 1;
-	return 1;
+	free_area(start, end, "initrd");
 }

-__setup("keepinitrd", keepinitrd_setup);
 #endif

 --
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
