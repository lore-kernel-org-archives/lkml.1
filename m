Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0BXIIp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 03:08:45 -0500
Received: from hera.kernel.org ([140.211.167.34]:58652 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab0BXIIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 03:08:41 -0500
Date: Wed, 24 Feb 2010 08:08:14 GMT
From: tip-bot for Jacob Pan <jacob.jun.pan@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jacob.jun.pan@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jacob.jun.pan@intel.com, tglx@linutronix.de
In-Reply-To: <43F901BD926A4E43B106BF17856F07559FB80D0A@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D0A@orsmsx508.amr.corp.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mrst] x86, mrst: Fill in PCI functions in x86_init layer
Message-ID: <tip-af2730f6eefce24c4ef1dc3f8267d33626db81bc@git.kernel.org>
Git-Commit-ID: af2730f6eefce24c4ef1dc3f8267d33626db81bc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Feb 2010 08:08:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af2730f6eefce24c4ef1dc3f8267d33626db81bc
Gitweb:     http://git.kernel.org/tip/af2730f6eefce24c4ef1dc3f8267d33626db81bc
Author:     Jacob Pan <jacob.jun.pan@intel.com>
AuthorDate: Fri, 12 Feb 2010 10:31:47 -0800
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 23 Feb 2010 23:15:19 -0800

x86, mrst: Fill in PCI functions in x86_init layer

This patch added Moorestown platform specific PCI init functions.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
LKML-Reference: <43F901BD926A4E43B106BF17856F07559FB80D0A@orsmsx508.amr.corp.intel.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/mrst.h |   15 +++++++++++++++
 arch/x86/kernel/mrst.c      |    3 +++
 2 files changed, 18 insertions(+), 0 deletions(-)

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
