Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYJTXA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYJTXA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:00:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbYJTXAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:00:14 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:51539 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYJTXAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:00:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Vv8eSLamNSFU8k4LGAnt85A2auNqVXYCkZ1a8b0Wxa+Eu43QpeYt1Z+1CuS4C+Rfr/
         TqbmOqrQ+Q7+elqfTfBuICqgIITwv69OBrxPQohG49dP0XWIKYcLsHn32wXnkdULUMyZ
         nmkcm4VxcSrVcsQp0snTMFcbuMEs98CKc1st4=
Subject: [PATCH] misc: replace remaining __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <rmk@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
       Paul Mackerras <paulus@samba.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 16:00:08 -0700
Message-Id: <1224543608.31861.228.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
These are the last occurences in-tree that are not already coming
through a subsystem tree.

xtensa, staging and blackfin (serial driver and a fb driver) will
catch the remaining ones as they merge.

 Documentation/DocBook/kernel-hacking.tmpl |    2 +-
 arch/arm/mach-iop13xx/include/mach/time.h |    4 ++--
 arch/arm/mach-pxa/include/mach/zylonite.h |    4 ++--
 arch/powerpc/include/asm/ptrace.h         |    2 +-
 drivers/net/usb/pegasus.c                 |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/DocBook/kernel-hacking.tmpl b/Documentation/DocBook/kernel-hacking.tmpl
index 4c63e58..ae15d55 100644
--- a/Documentation/DocBook/kernel-hacking.tmpl
+++ b/Documentation/DocBook/kernel-hacking.tmpl
@@ -1105,7 +1105,7 @@ static struct block_device_operations opt_fops = {
     </listitem>
     <listitem>
      <para>
-      Function names as strings (__FUNCTION__).
+      Function names as strings (__func__).
      </para>
     </listitem>
     <listitem>
diff --git a/arch/arm/mach-iop13xx/include/mach/time.h b/arch/arm/mach-iop13xx/include/mach/time.h
index 49213d9..d6d5252 100644
--- a/arch/arm/mach-iop13xx/include/mach/time.h
+++ b/arch/arm/mach-iop13xx/include/mach/time.h
@@ -41,7 +41,7 @@ static inline unsigned long iop13xx_core_freq(void)
 		return 1200000000;
 	default:
 		printk("%s: warning unknown frequency, defaulting to 800Mhz\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 800000000;
@@ -60,7 +60,7 @@ static inline unsigned long iop13xx_xsi_bus_ratio(void)
 		return 4;
 	default:
 		printk("%s: warning unknown ratio, defaulting to 2\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 2;
diff --git a/arch/arm/mach-pxa/include/mach/zylonite.h b/arch/arm/mach-pxa/include/mach/zylonite.h
index 0d35ca0..bf6785a 100644
--- a/arch/arm/mach-pxa/include/mach/zylonite.h
+++ b/arch/arm/mach-pxa/include/mach/zylonite.h
@@ -30,7 +30,7 @@ extern void zylonite_pxa300_init(void);
 static inline void zylonite_pxa300_init(void)
 {
 	if (cpu_is_pxa300() || cpu_is_pxa310())
-		panic("%s: PXA300/PXA310 not supported\n", __FUNCTION__);
+		panic("%s: PXA300/PXA310 not supported\n", __func__);
 }
 #endif
 
@@ -40,7 +40,7 @@ extern void zylonite_pxa320_init(void);
 static inline void zylonite_pxa320_init(void)
 {
 	if (cpu_is_pxa320())
-		panic("%s: PXA320 not supported\n", __FUNCTION__);
+		panic("%s: PXA320 not supported\n", __func__);
 }
 #endif
 
diff --git a/arch/powerpc/include/asm/ptrace.h b/arch/powerpc/include/asm/ptrace.h
index 734e075..280a90c 100644
--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -129,7 +129,7 @@ extern int ptrace_put_reg(struct task_struct *task, int regno,
 #define CHECK_FULL_REGS(regs)						      \
 do {									      \
 	if ((regs)->trap & 1)						      \
-		printk(KERN_CRIT "%s: partial register set\n", __FUNCTION__); \
+		printk(KERN_CRIT "%s: partial register set\n", __func__); \
 } while (0)
 #endif /* __powerpc64__ */
 
diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 38b90e7..7914867 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -168,7 +168,7 @@ static int get_registers(pegasus_t * pegasus, __u16 indx, __u16 size,
 			netif_device_detach(pegasus->net);
 		if (netif_msg_drv(pegasus) && printk_ratelimit())
 			dev_err(&pegasus->intf->dev, "%s, status %d\n",
-					__FUNCTION__, ret);
+					__func__, ret);
 		goto out;
 	}
 
@@ -192,7 +192,7 @@ static int set_registers(pegasus_t * pegasus, __u16 indx, __u16 size,
 	if (!buffer) {
 		if (netif_msg_drv(pegasus))
 			dev_warn(&pegasus->intf->dev, "out of memory in %s\n",
-					__FUNCTION__);
+					__func__);
 		return -ENOMEM;
 	}
 	memcpy(buffer, data, size);
-- 
1.6.0.2



