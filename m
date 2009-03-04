Return-Path: <linux-kernel-owner+w=401wt.eu-S1757554AbZCDS5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554AbZCDS5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 13:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZCDS5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 13:57:22 -0500
Received: from relay1.sgi.com ([192.48.179.29]:51963 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755229AbZCDS5V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 13:57:21 -0500
Date: Wed, 4 Mar 2009 12:57:19 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3 v7] SGI RTC: loop through installed UV blades
Message-ID: <20090304185719.GB24419@sgi.com>
References: <20090304185413.GA24385@sgi.com> <20090304185605.GA24419@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090304185605.GA24419@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add macro to loop through each possible blade.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>

---

 arch/x86/include/asm/uv/uv_hub.h |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux/arch/x86/include/asm/uv/uv_hub.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-03-04 09:38:04.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-03-04 10:51:20.000000000 -0600
@@ -199,6 +199,10 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define SCIR_CPU_ACTIVITY	0x02	/* not idle */
 #define SCIR_CPU_HB_INTERVAL	(HZ)	/* once per second */
 
+/* Loop through all installed blades */
+#define for_each_possible_blade(bid)		\
+	for ((bid) = 0; (bid) < uv_num_possible_blades(); (bid)++)
+
 /*
  * Macros for converting between kernel virtual addresses, socket local physical
  * addresses, and UV global physical addresses.
