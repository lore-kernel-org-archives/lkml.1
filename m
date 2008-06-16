Return-Path: <linux-kernel-owner+w=401wt.eu-S1757205AbYFPRJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205AbYFPRJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 13:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbYFPRJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 13:09:15 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36213 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754359AbYFPRJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 13:09:14 -0400
Date: Mon, 16 Jun 2008 12:09:10 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] - Increase MAX_APICS for very large x86_64 configs
Message-ID: <20080616170910.GA24930@sgi.com>
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

The patch has no effect on any 32-bit kernel. It adds ~4k to the size
of 64-bit kernels but only if NR_CPUS > 255.

This is a repost of an earlier patch (4/16) that  was implicated in
a random-qa failure. I have not been able to reproduce the failure
using the same boot args & config.  Best guess is that some other
patch caused random data corruption & this patch was a victim.



 include/asm-x86/mpspec_def.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/include/asm-x86/mpspec_def.h
===================================================================
--- linux.orig/include/asm-x86/mpspec_def.h	2008-06-08 09:05:51.140046529 -0500
+++ linux/include/asm-x86/mpspec_def.h	2008-06-08 09:05:55.244550306 -0500
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
