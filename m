Return-Path: <linux-kernel-owner+w=401wt.eu-S1753326Ab0AKM0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab0AKM0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:26:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456Ab0AKM0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:26:05 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:56335 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab0AKM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:26:03 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:55:58 +0530
Message-Id: <20100111122558.22050.431.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 5/7] X86 Support for Uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86 support for Uprobes

Signed-off-by: Jim Keniston <jkenisto@us.ibm.com>
---
 arch/x86/Kconfig               |    1 +
 arch/x86/include/asm/uprobes.h |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

Index: new_uprobes.git/arch/x86/Kconfig
===================================================================
--- new_uprobes.git.orig/arch/x86/Kconfig
+++ new_uprobes.git/arch/x86/Kconfig
@@ -51,6 +51,7 @@ config X86
 	select HAVE_KERNEL_LZMA
 	select HAVE_HW_BREAKPOINT
 	select HAVE_UBP
+	select HAVE_UPROBES
 	select HAVE_ARCH_KMEMCHECK
 	select HAVE_USER_RETURN_NOTIFIER
 
Index: new_uprobes.git/arch/x86/include/asm/uprobes.h
===================================================================
--- /dev/null
+++ new_uprobes.git/arch/x86/include/asm/uprobes.h
@@ -0,0 +1,27 @@
+#ifndef _ASM_UPROBES_H
+#define _ASM_UPROBES_H
+/*
+ *  Userspace Probes (UProbes)
+ *  uprobes.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2008, 2009
+ */
+#include <linux/signal.h>
+
+#define BREAKPOINT_SIGNAL SIGTRAP
+#define SSTEP_SIGNAL SIGTRAP
+#endif				/* _ASM_UPROBES_H */
