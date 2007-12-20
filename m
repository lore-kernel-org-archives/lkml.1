Return-Path: <linux-kernel-owner+w=401wt.eu-S932366AbXLTNm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbXLTNm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763842AbXLTNmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:42:04 -0500
Received: from mga03.intel.com ([143.182.124.21]:18075 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764013AbXLTNl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:41:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,189,1196668800"; 
   d="scan'208";a="346087974"
Date: Thu, 20 Dec 2007 14:40:12 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 4/5] x86, ptrace: overflow signal API
Message-ID: <20071220144012.A29998@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Establish the user API for sending a user-defined signal to the traced task on a BTS buffer overflow.

This should complete the user API for the BTS ptrace extension.
The patches so far implement wrap-around overflow handling as is needed for debugging.

The remaining open is another overflow handling mechanism that sends a signal to the traced task on a buffer overflow.
This will take some more time from my side.

Since, from a user perspective, this occurs behind the scenes, the patch set should already be useful. More features may/will be added on top of it (overflow signal, pageable back-up buffers, kernel tracing, core file support, profiling, ...).


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
 ---

Index: linux-2.6-x86/include/asm-x86/ptrace-abi.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/ptrace-abi.h	2007-12-20 13:52:09.%N +0100
+++ linux-2.6-x86/include/asm-x86/ptrace-abi.h	2007-12-20 13:52:14.%N +0100
@@ -88,11 +88,13 @@
 	unsigned int size;
 	/* bitmask of below flags */
 	unsigned int flags;
+	/* buffer overflow signal */
+	unsigned int signal;
 };
 
 #define PTRACE_BTS_O_TRACE	0x1 /* branch trace */
 #define PTRACE_BTS_O_SCHED	0x2 /* scheduling events w/ jiffies */
-#define PTRACE_BTS_O_SIGNAL     0x4 /* send SIG? on buffer overflow
+#define PTRACE_BTS_O_SIGNAL     0x4 /* send SIG<signal> on buffer overflow
 				       instead of wrapping around */
 #define PTRACE_BTS_O_CUT_SIZE	0x8 /* cut requested size to max available
 				       instead of failing */
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

