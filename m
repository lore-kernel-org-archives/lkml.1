Return-Path: <linux-kernel-owner+w=401wt.eu-S934800AbXKPUJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934800AbXKPUJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 15:09:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXKPUFz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 15:05:55 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:46720 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934744AbXKPUFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 15:05:54 -0500
Message-Id: <20071116200513.955851047@polymtl.ca>
References: <20071116200238.740495156@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 16 Nov 2007 15:02:43 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [rfc-patch 5/9] Add __discard section to x86
Content-Disposition: inline; filename=add-discard-section-to-x86.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 16 Nov 2007 20:05:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a __discard sectionto the linker script. Code produced in this section will
not be put in the vmlinux file. This is useful when we have to calculate the
size of an instruction before actually declaring it (for alignment purposes for
instance). This is used by the immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: H. Peter Anvin <hpa@zytor.com>
CC: Andi Kleen <ak@muc.de>
CC: Chuck Ebbert <cebbert@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/vmlinux_32.lds.S |    1 +
 arch/x86/kernel/vmlinux_64.lds.S |    1 +
 2 files changed, 2 insertions(+)

Index: linux-2.6-lttng/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/vmlinux_32.lds.S	2007-11-14 14:10:43.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/vmlinux_32.lds.S	2007-11-14 14:11:32.000000000 -0500
@@ -205,6 +205,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exitcall.exit)
+	*(__discard)
 	}
 
   STABS_DEBUG
Index: linux-2.6-lttng/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86/kernel/vmlinux_64.lds.S	2007-11-14 14:10:46.000000000 -0500
+++ linux-2.6-lttng/arch/x86/kernel/vmlinux_64.lds.S	2007-11-14 14:11:48.000000000 -0500
@@ -227,6 +227,7 @@ SECTIONS
   /DISCARD/ : {
 	*(.exitcall.exit)
 	*(.eh_frame)
+	*(__discard)
 	}
 
   STABS_DEBUG

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
