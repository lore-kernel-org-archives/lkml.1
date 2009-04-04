Return-Path: <linux-kernel-owner+w=401wt.eu-S935961AbZDDAQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935961AbZDDAQB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 20:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761149AbZDDAPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 20:15:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:54057 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759565AbZDDAPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 20:15:50 -0400
Message-ID: <49D6A6B9.6060501@kernel.org>
Date: Fri, 03 Apr 2009 17:15:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: consistent about warm_reset_vector for UN_NON_UNIQUE_APIC
References: <49D6A631.2020706@sun.com> <49D6A692.6040400@kernel.org>
In-Reply-To: <49D6A692.6040400@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: cleanup

didn't set it for UV_NON_UNIQUE_APIC, so don't restore it

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/smpboot.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -822,10 +822,12 @@ do_rest:
 	/* mark "stuck" area as not stuck */
 	*((volatile unsigned long *)trampoline_base) = 0;
 
-	/*
-	 * Cleanup possible dangling ends...
-	 */
-	smpboot_restore_warm_reset_vector();
+	if (get_uv_system_type() != UV_NON_UNIQUE_APIC) {
+		/*
+		 * Cleanup possible dangling ends...
+		 */
+		smpboot_restore_warm_reset_vector();
+	}
 
 	return boot_error;
 }
