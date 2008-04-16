Return-Path: <linux-kernel-owner+w=401wt.eu-S932738AbYDPQjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932738AbYDPQjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 12:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759095AbYDPQjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 12:39:41 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55033 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758451AbYDPQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 12:39:41 -0400
Date: Wed, 16 Apr 2008 11:39:36 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - Increase MAX_APICS for large configs
Message-ID: <20080416163936.GA23099@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Increase the maximum number of apics when running very large
configurations. This patch has no affect on most systems.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---

I think this area of the code will be substantially changed when
the full x2apic patch is available. In the meantime, this seems
like an acceptible alternative. The patch has no effect on any 32-bit
kernel. It adds ~4k to the size of 64-bit kernels but only if
NR_CPUS > 255.


 include/asm-x86/mpspec_def.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/include/asm-x86/mpspec_def.h
===================================================================
--- linux.orig/include/asm-x86/mpspec_def.h	2008-03-29 06:45:28.000000000 -0500
+++ linux/include/asm-x86/mpspec_def.h	2008-03-31 14:17:01.000000000 -0500
@@ -17,10 +17,11 @@
 # define MAX_MPC_ENTRY 1024
 # define MAX_APICS      256
 #else
-/*
- * A maximum of 255 APICs with the current APIC ID architecture.
- */
-# define MAX_APICS 255
+# if NR_CPUS <= 255
+#  define MAX_APICS     255
+# else
+#  define MAX_APICS   32768
+# endif
 #endif
 
 struct intel_mp_floating {
