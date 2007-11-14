Return-Path: <linux-kernel-owner+w=401wt.eu-S1763030AbXKNTRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763030AbXKNTRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 14:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbXKNTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 14:16:56 -0500
Received: from tomts25-srv.bellnexxia.net ([209.226.175.188]:55723 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbXKNTQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 14:16:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAD/YOkdMROHU/2dsb2JhbACBXA
Date: Wed, 14 Nov 2007 14:16:52 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] Add __discard section to x86
Message-ID: <20071114191652.GA4438@Krystal>
References: <20071113204033.GB7450@Krystal> <473A166E.3070708@zytor.com> <20071113220227.GB9057@Krystal> <473A26A2.7090007@zytor.com> <20071114003409.GA18032@Krystal> <473A4909.1020609@zytor.com> <20071114014445.GB19901@Krystal> <473A6471.4040700@zytor.com> <20071114185220.GA29533@Krystal> <473B45C4.5030501@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <473B45C4.5030501@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:16:05 up 11 days, 21 min,  3 users,  load average: 2.26, 1.09,
	0.99
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add a __discard sectionto the linker script. Code produced in this section will
not be put in the vmlinux file. This is useful when we have to calculate the
size of an instruction before actually declaring it (for alignment purposes for
instance). This is used by the immediate values.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
CC: "H. Peter Anvin" <hpa@zytor.com>
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
