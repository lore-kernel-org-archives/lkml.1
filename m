Return-Path: <linux-kernel-owner+w=401wt.eu-S1754883AbXKZNgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883AbXKZNgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 08:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXKZNgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 08:36:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:52493 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855AbXKZNgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:36:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:to:subject:message-id:from:date;
        b=lCazgotN62HJzp+McYmTAta2VzxsWlzAwvGpWZQQUP1i7BbVHa8D1D6DxWxXJ5fh6bVz4c/JmSaAKcg8myaCnl8ZxUxwivmV682p9Phd2vd+wPCBDmXALJgPDGEylFEbMmLpWczc/8lr9gDe1aWNLviRsVQDBXcuB/Ex519dXXE=
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH] Add CONFIG_BITS to remove the test in arch/x86/Makefile
Message-Id: <E1Iwe87-0003X7-47@localhost>
From: Loic Grenie <loic.grenie@gmail.com>
Date: Mon, 26 Nov 2007 14:36:07 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    I propose the following patch to arch/x86/Makefile and Kconfig.

Actions:

     - Add a BITS variable to Kconfig which takes value 32 or 64 according
       to 64BIT.
     - Modify arch/x86/Makefile to use CONFIG_BITS instead of testing
       ARCH.

How this could be expanded:

     - Either remove BITS from arch/x86/Makefile_?? or change its definition
       (I expect to do one of those if my patch is accepted).
     - Add it to other arhitectures ? Maybe CONFIG_BITS could be useful
       somewhere in the code ?


    Kindly,

        Loïc Grenié


Signed-off-by: Loïc Grenié <loic.grenie@gmail.com>
---
 arch/x86/Kconfig  |    5 +++++
 arch/x86/Makefile |    9 ++-------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 368864d..c0935fd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -15,6 +15,11 @@ config X86_32
 config X86_64
 	def_bool 64BIT
 
+config BITS
+	int
+	default "64" if 64BIT
+	default "32"
+
 ### Arch settings
 config X86
 	bool
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 116b03a..035adba 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -10,11 +10,6 @@ endif
 # No need to remake these files
 $(srctree)/arch/x86/Makefile%: ;
 
-ifeq ($(CONFIG_X86_32),y)
-        include $(srctree)/arch/x86/Makefile_32
-else
-        include $(srctree)/arch/x86/Makefile_64
-endif
-
-
+CONFIG_BITS ?= 32
 
+include $(srctree)/arch/x86/Makefile_$(CONFIG_BITS)
-- 
1.5.3.4

