Return-Path: <linux-kernel-owner+w=401wt.eu-S1757370AbZCDTth@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757370AbZCDTth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:49:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbZCDTtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:49:21 -0500
Received: from hera.kernel.org ([140.211.167.34]:44737 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704AbZCDTtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:49:20 -0500
Date: Wed, 4 Mar 2009 19:48:44 GMT
From: Dimitri Sivanich <sivanich@sgi.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, akpm@linux-foundation.org, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, johnstul@us.ibm.com, tglx@linutronix.de,
       sivanich@sgi.com, mingo@elte.hu
In-Reply-To: <20090304185719.GB24419@sgi.com>
References: <20090304185719.GB24419@sgi.com>
Subject: [tip:x86/uv] x86: UV, SGI RTC: loop through installed UV blades
Message-ID: <tip-8661984f628c6f7d9cbaac6697f26d6b0be3ad3b@git.kernel.org>
Git-Commit-ID: 8661984f628c6f7d9cbaac6697f26d6b0be3ad3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 04 Mar 2009 19:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8661984f628c6f7d9cbaac6697f26d6b0be3ad3b
Gitweb:     http://git.kernel.org/tip/8661984f628c6f7d9cbaac6697f26d6b0be3ad3b
Author:     "Dimitri Sivanich" <sivanich@sgi.com>
AuthorDate: Wed, 4 Mar 2009 12:57:19 -0600
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Mar 2009 20:25:37 +0100

x86: UV, SGI RTC: loop through installed UV blades

Add macro to loop through each possible blade.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: john stultz <johnstul@us.ibm.com>
LKML-Reference: <20090304185719.GB24419@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/uv/uv_hub.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 777327e..9f4dfba 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -199,6 +199,10 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __uv_hub_info);
 #define SCIR_CPU_ACTIVITY	0x02	/* not idle */
 #define SCIR_CPU_HB_INTERVAL	(HZ)	/* once per second */
 
+/* Loop through all installed blades */
+#define for_each_possible_blade(bid)		\
+	for ((bid) = 0; (bid) < uv_num_possible_blades(); (bid)++)
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
