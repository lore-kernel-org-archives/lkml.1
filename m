Return-Path: <linux-kernel-owner+w=401wt.eu-S1753874AbYCRFNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbYCRFNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYCRFNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:13:13 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:43245 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYCRFNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:13:12 -0400
Date: Mon, 17 Mar 2008 23:13:10 -0600
From: Grant Likely <grant.likely@secretlab.ca>
Subject: [PATCH][POWERPC] bootwrapper: Add entries for tqm8540 and sbc85xx
To: bunk@kernel.org, paul.gortmaker@windriver.com, galak@kernel.crashing.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-id: <20080318051112.17634.63025.stgit@trillian.secretlab.ca>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
User-Agent: StGIT/0.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

The wrapper script didn't have entries for the TQM8540 board and the
SBC8548 or SBC8560 boards.  I've assumed that the TQM8540 console is
8250 based and not CPM based by looking at its defconfig.  There was
also a trailing * on the TQM8555 entry that I removed too.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---

Paulus; this fixes the broken defconfig issues that Adrian raised.  Can you
please pick this up for merger into 2.6.25?

Thanks,
g.

 arch/powerpc/boot/Makefile |    4 ++--
 arch/powerpc/boot/wrapper  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/boot/Makefile b/arch/powerpc/boot/Makefile
index 4974d9e..1aded8f 100644
--- a/arch/powerpc/boot/Makefile
+++ b/arch/powerpc/boot/Makefile
@@ -253,8 +253,8 @@ image-$(CONFIG_TQM8540)			+= cuImage.tqm8540
 image-$(CONFIG_TQM8541)			+= cuImage.tqm8541
 image-$(CONFIG_TQM8555)			+= cuImage.tqm8555
 image-$(CONFIG_TQM8560)			+= cuImage.tqm8560
-image-$(CONFIG_SBC8548)			+= cuImage.tqm8548
-image-$(CONFIG_SBC8560)			+= cuImage.tqm8560
+image-$(CONFIG_SBC8548)			+= cuImage.sbc8548
+image-$(CONFIG_SBC8560)			+= cuImage.sbc8560
 
 # Board ports in arch/powerpc/platform/embedded6xx/Kconfig
 image-$(CONFIG_STORCENTER)		+= cuImage.storcenter
diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
index d50e498..8f8b849 100755
--- a/arch/powerpc/boot/wrapper
+++ b/arch/powerpc/boot/wrapper
@@ -174,10 +174,10 @@ cuboot*)
     *-mpc83*)
         platformo=$object/cuboot-83xx.o
         ;;
-    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555*)
+    *-tqm8541|*-mpc8560*|*-tqm8560|*-tqm8555)
         platformo=$object/cuboot-85xx-cpm2.o
         ;;
-    *-mpc85*)
+    *-mpc85*|*-tqm8540|*-sbc85*)
         platformo=$object/cuboot-85xx.o
         ;;
     esac

