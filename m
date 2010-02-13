Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab0BMBl6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:41:58 -0500
Received: from mga01.intel.com ([192.55.52.88]:45189 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545Ab0BMBky convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="772528659"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:52 -0800
Subject: [PATCH 4/8] x86/mrst: Fill in PCI functions in x86_init layer
Thread-Topic: [PATCH 4/8] x86/mrst: Fill in PCI functions in x86_init layer
Thread-Index: AcqsTZO9LHYsmb8kRQOI+w8hQq61kg==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D0A@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From a2d7c3f1f4a4035c4b2c145f9ee04aee0a34fb28 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Fri, 12 Feb 2010 10:31:47 -0800
Subject: [PATCH 4/8] x86/mrst: Fill in PCI functions in x86_init layer

This patch added Moorestown platform specific PCI init functions.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/mrst.h |   15 +++++++++++++++
 arch/x86/kernel/mrst.c      |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/mrst.h

diff --git a/arch/x86/include/asm/mrst.h b/arch/x86/include/asm/mrst.h
new file mode 100644
index 0000000..57a177a
--- /dev/null
+++ b/arch/x86/include/asm/mrst.h
@@ -0,0 +1,15 @@
+/*
+ * mrst.h: Intel Moorestown platform specific setup code
+ *
+ * (C) Copyright 2009 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _ASM_X86_MRST_H
+#define _ASM_X86_MRST_H
+extern int pci_mrst_init(void);
+
+#endif /* _ASM_X86_MRST_H */
diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index bdf9b17..98440e1 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -25,5 +25,8 @@ void __init x86_mrst_early_setup(void)
 	x86_init.resources.probe_roms = x86_init_noop;
 	x86_init.resources.reserve_resources = x86_init_noop;
 
+	x86_init.pci.init = pci_mrst_init;
+	x86_init.pci.fixup_irqs = x86_init_noop;
+
 	legacy_pic = &null_legacy_pic;
 }
-- 
1.6.5.3

