Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZEJAKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZEJAKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 20:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZEJAKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 20:10:33 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:46159 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZEJAKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 20:10:32 -0400
X-Greylist: delayed 426 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 May 2009 20:10:32 EDT
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: Disable generation of sse3 instructions in kernel build.
Date: Sat, 9 May 2009 19:03:22 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NnhBKgEckkAkZQX"
Message-Id: <200905091903.25745.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_NnhBKgEckkAkZQX
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Ref: 2.6.30-rcX
The option to disable sse3 instructions needs to be added to build system for x86.
Otherwise strange and mysterious things happen (tm).

Like (also attached):
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8c86b72..3c0df6f 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -103,7 +103,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 #
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
-KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-sse3 -mno-3dnow,)

 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)

--Boundary-00=_NnhBKgEckkAkZQX
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="00-fix-kbuild-flags.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="00-fix-kbuild-flags.patch"

diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 8c86b72..3c0df6f 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -103,7 +103,7 @@ KBUILD_CFLAGS += -Wno-sign-compare
 #
 KBUILD_CFLAGS += -fno-asynchronous-unwind-tables
 # prevent gcc from generating any FP code by mistake
-KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-3dnow,)
+KBUILD_CFLAGS += $(call cc-option,-mno-sse -mno-mmx -mno-sse2 -mno-sse3 -mno-3dnow,)
 
 KBUILD_CFLAGS += $(mflags-y)
 KBUILD_AFLAGS += $(mflags-y)

--Boundary-00=_NnhBKgEckkAkZQX--
