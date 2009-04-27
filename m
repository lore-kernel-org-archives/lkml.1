Return-Path: <linux-kernel-owner+w=401wt.eu-S1755073AbZD0Giy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbZD0Giy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 02:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbZD0Gio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 02:38:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:41048 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbZD0Gin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 02:38:43 -0400
Message-ID: <49F552D0.5050505@kernel.org>
Date: Sun, 26 Apr 2009 23:38:08 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove duplicated macros.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


XAPIC_DEST_* is dupliicated to the one in apicdef.h

[ Impact: cleanup ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/summit_32.c |    7 -------
 1 file changed, 7 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/summit_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/summit_32.c
+++ linux-2.6/arch/x86/kernel/apic/summit_32.c
@@ -173,13 +173,6 @@ static inline int is_WPEG(struct rio_det
 		rio->type == LookOutAWPEG || rio->type == LookOutBWPEG);
 }
 
-
-/* In clustered mode, the high nibble of APIC ID is a cluster number.
- * The low nibble is a 4-bit bitmap. */
-#define XAPIC_DEST_CPUS_SHIFT	4
-#define XAPIC_DEST_CPUS_MASK	((1u << XAPIC_DEST_CPUS_SHIFT) - 1)
-#define XAPIC_DEST_CLUSTER_MASK	(XAPIC_DEST_CPUS_MASK << XAPIC_DEST_CPUS_SHIFT)
-
 #define SUMMIT_APIC_DFR_VALUE	(APIC_DFR_CLUSTER)
 
 static const struct cpumask *summit_target_cpus(void)
