Return-Path: <linux-kernel-owner+w=401wt.eu-S1752525AbZHHUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbZHHUVU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 16:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZHHUVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 16:21:19 -0400
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:33146 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZHHUVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 16:21:19 -0400
Date: Sat, 8 Aug 2009 13:21:13 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: Simplify calls to cpuid by using + for in/out
 constraints
Message-ID: <20090808202113.GA21962@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-TUID: 6cba7f655b58ce4b
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Build-tested only.

 arch/x86/include/asm/processor.h |    7 +++----
 arch/x86/xen/enlighten.c         |    7 +++----
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c776826..dfa947e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -180,11 +180,10 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 {
 	/* ecx is often an input as well as an output. */
 	asm("cpuid"
-	    : "=a" (*eax),
+	    : "+a" (*eax),
 	      "=b" (*ebx),
-	      "=c" (*ecx),
-	      "=d" (*edx)
-	    : "0" (*eax), "2" (*ecx));
+	      "+c" (*ecx),
+	      "=d" (*edx));
 }
 
 static inline void load_cr3(pgd_t *pgdir)
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 6ee2ef8..6eab164 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -190,11 +190,10 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 	}
 
 	asm(XEN_EMULATE_PREFIX "cpuid"
-		: "=a" (*ax),
+		: "+a" (*ax),
 		  "=b" (*bx),
-		  "=c" (*cx),
-		  "=d" (*dx)
-		: "0" (*ax), "2" (*cx));
+		  "+c" (*cx),
+		  "=d" (*dx));
 
 	*cx &= maskecx;
 	*dx &= maskedx;
-- 
1.5.6.5

