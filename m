Return-Path: <linux-kernel-owner+w=401wt.eu-S933245AbYDPVl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933245AbYDPVl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 17:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765731AbYDPVgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 17:36:37 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:53222 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765671AbYDPVge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 17:36:34 -0400
Message-Id: <20080416213555.748355843@polymtl.ca>
References: <20080416213426.298498397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 16 Apr 2008 17:34:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@muc.de>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [RFC patch 21/27] Add __discard section to x86
Content-Disposition: inline; filename=add-discard-section-to-x86.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 16 Apr 2008 21:35:56 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
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

Index: linux-2.6-sched-devel/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/vmlinux_32.lds.S	2008-04-16 11:07:19.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/vmlinux_32.lds.S	2008-04-16 11:17:04.000000000 -0400
@@ -213,6 +213,7 @@ SECTIONS
   /* Sections to be discarded */
   /DISCARD/ : {
 	*(.exitcall.exit)
+	*(__discard)
 	}
 
   STABS_DEBUG
Index: linux-2.6-sched-devel/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6-sched-devel.orig/arch/x86/kernel/vmlinux_64.lds.S	2008-04-16 11:07:19.000000000 -0400
+++ linux-2.6-sched-devel/arch/x86/kernel/vmlinux_64.lds.S	2008-04-16 11:17:04.000000000 -0400
@@ -246,6 +246,7 @@ SECTIONS
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
