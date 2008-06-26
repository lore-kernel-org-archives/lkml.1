Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbYFZMuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbYFZMuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758502AbYFZMg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:36:57 -0400
Received: from 238.225.broadband7.iol.cz ([88.102.225.238]:20624 "EHLO
	monstr.eu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758204AbYFZMgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:36:55 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jun 2008 08:36:54 EDT
From: monstr@seznam.cz
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, john.williams@petalogix.com, matthew@wil.cx,
       will.newton@gmail.com, drepper@redhat.com,
       microblaze-uclinux@itee.uq.edu.au, grant.likely@secretlab.ca,
       linuxppc-dev@ozlabs.org, vapier.adi@gmail.com, alan@lxorguk.ukuu.org.uk,
       hpa@zytor.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 26/60] microblaze_v4: time support
Date: Thu, 26 Jun 2008 14:29:55 +0200
Message-Id: <1214483429-32360-27-git-send-email-monstr@seznam.cz>
X-Mailer: git-send-email 1.5.4.GIT
In-Reply-To: <1214483429-32360-26-git-send-email-monstr@seznam.cz>
References: <1214483429-32360-1-git-send-email-monstr@seznam.cz>
 <1214483429-32360-2-git-send-email-monstr@seznam.cz>
 <1214483429-32360-3-git-send-email-monstr@seznam.cz>
 <1214483429-32360-4-git-send-email-monstr@seznam.cz>
 <1214483429-32360-5-git-send-email-monstr@seznam.cz>
 <1214483429-32360-6-git-send-email-monstr@seznam.cz>
 <1214483429-32360-7-git-send-email-monstr@seznam.cz>
 <1214483429-32360-8-git-send-email-monstr@seznam.cz>
 <1214483429-32360-9-git-send-email-monstr@seznam.cz>
 <1214483429-32360-10-git-send-email-monstr@seznam.cz>
 <1214483429-32360-11-git-send-email-monstr@seznam.cz>
 <1214483429-32360-12-git-send-email-monstr@seznam.cz>
 <1214483429-32360-13-git-send-email-monstr@seznam.cz>
 <1214483429-32360-14-git-send-email-monstr@seznam.cz>
 <1214483429-32360-15-git-send-email-monstr@seznam.cz>
 <1214483429-32360-16-git-send-email-monstr@seznam.cz>
 <1214483429-32360-17-git-send-email-monstr@seznam.cz>
 <1214483429-32360-18-git-send-email-monstr@seznam.cz>
 <1214483429-32360-19-git-send-email-monstr@seznam.cz>
 <1214483429-32360-20-git-send-email-monstr@seznam.cz>
 <1214483429-32360-21-git-send-email-monstr@seznam.cz>
 <1214483429-32360-22-git-send-email-monstr@seznam.cz>
 <1214483429-32360-23-git-send-email-monstr@seznam.cz>
 <1214483429-32360-24-git-send-email-monstr@seznam.cz>
 <1214483429-32360-25-git-send-email-monstr@seznam.cz>
 <1214483429-32360-26-git-send-email-monstr@seznam.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 include/asm-microblaze/delay.h |   30 ++++++++++++++++++++++++++++++
 include/asm-microblaze/timex.h |   18 ++++++++++++++++++
 2 files changed, 48 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-microblaze/delay.h
 create mode 100644 include/asm-microblaze/timex.h

diff --git a/include/asm-microblaze/delay.h b/include/asm-microblaze/delay.h
new file mode 100644
index 0000000..cdafdad
--- /dev/null
+++ b/include/asm-microblaze/delay.h
@@ -0,0 +1,30 @@
+/*
+ * include/asm-microblaze/delay.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_MICROBLAZE_DELAY_H
+#define _ASM_MICROBLAZE_DELAY_H
+
+extern unsigned long loops_per_jiffy;
+
+extern inline void __delay(unsigned long loops)
+{
+	asm volatile ("# __delay		\n\t"		\
+			"1: addi	%0, %0, -1 \t\n"	\
+			"bneid	%0, 1b		\t\n"		\
+			"nop			\t\n"
+			: "=r" (loops)
+			: "0" (loops));
+}
+
+static inline void udelay(unsigned long usec)
+{
+}
+
+#endif /* _ASM_MICROBLAZE_DELAY_H */
diff --git a/include/asm-microblaze/timex.h b/include/asm-microblaze/timex.h
new file mode 100644
index 0000000..678525d
--- /dev/null
+++ b/include/asm-microblaze/timex.h
@@ -0,0 +1,18 @@
+/*
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ */
+
+#ifndef _ASM_MICROBLAZE_TIMEX_H
+#define _ASM_MICROBLAZE_TIMEX_H
+
+#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
+
+typedef unsigned long cycles_t;
+
+#define get_cycles()	(0)
+
+#endif /* _ASM_TIMEX_H */
-- 
1.5.4.GIT

