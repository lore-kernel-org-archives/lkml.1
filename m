Return-Path: <linux-kernel-owner+w=401wt.eu-S1764266AbYDQJMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764266AbYDQJMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 05:12:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758491AbYDQJKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 05:10:55 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:58880
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbYDQJKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 05:10:52 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org,
       Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 04/45] s390: KVM preparation: address of the 64bit extint parm in lowcore
Date: Thu, 17 Apr 2008 12:10:09 +0300
Message-Id: <1208423450-29415-5-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1208423450-29415-1-git-send-email-avi@qumranet.com>
References: <1208423450-29415-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

The address 0x11b8 is used by z/VM for pfault and diag 250 I/O to
provide a 64 bit extint parameter. virtio uses the same address, so
its time to update the lowcore structure.

Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-s390/lowcore.h |   15 ++++++++++-----
 1 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/asm-s390/lowcore.h b/include/asm-s390/lowcore.h
index 801a6fd..e0857c5 100644
--- a/include/asm-s390/lowcore.h
+++ b/include/asm-s390/lowcore.h
@@ -380,27 +380,32 @@ struct _lowcore
         /* whether the kernel died with panic() or not */
         __u32        panic_magic;              /* 0xe00 */
 
-	__u8         pad13[0x1200-0xe04];      /* 0xe04 */
+	__u8         pad13[0x11b8-0xe04];      /* 0xe04 */
+
+	/* 64 bit extparam used for pfault, diag 250 etc  */
+	__u64        ext_params2;               /* 0x11B8 */
+
+	__u8         pad14[0x1200-0x11C0];      /* 0x11C0 */
 
         /* System info area */ 
 
 	__u64        floating_pt_save_area[16]; /* 0x1200 */
 	__u64        gpregs_save_area[16];      /* 0x1280 */
 	__u32        st_status_fixed_logout[4]; /* 0x1300 */
-	__u8         pad14[0x1318-0x1310];      /* 0x1310 */
+	__u8         pad15[0x1318-0x1310];      /* 0x1310 */
 	__u32        prefixreg_save_area;       /* 0x1318 */
 	__u32        fpt_creg_save_area;        /* 0x131c */
-	__u8         pad15[0x1324-0x1320];      /* 0x1320 */
+	__u8         pad16[0x1324-0x1320];      /* 0x1320 */
 	__u32        tod_progreg_save_area;     /* 0x1324 */
 	__u32        cpu_timer_save_area[2];    /* 0x1328 */
 	__u32        clock_comp_save_area[2];   /* 0x1330 */
-	__u8         pad16[0x1340-0x1338];      /* 0x1338 */ 
+	__u8         pad17[0x1340-0x1338];      /* 0x1338 */
 	__u32        access_regs_save_area[16]; /* 0x1340 */ 
 	__u64        cregs_save_area[16];       /* 0x1380 */
 
 	/* align to the top of the prefix area */
 
-	__u8         pad17[0x2000-0x1400];      /* 0x1400 */
+	__u8         pad18[0x2000-0x1400];      /* 0x1400 */
 #endif /* !__s390x__ */
 } __attribute__((packed)); /* End structure*/
 
-- 
1.5.5

