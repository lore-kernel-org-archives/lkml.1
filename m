Return-Path: <linux-kernel-owner+w=401wt.eu-S1757100AbZCCPUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757100AbZCCPUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 10:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754371AbZCCPUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 10:20:19 -0500
Received: from relay2.sgi.com ([192.48.179.30]:33508 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271AbZCCPUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 10:20:18 -0500
Date: Tue, 3 Mar 2009 09:20:16 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6 v6] SGI RTC: loop through installed UV blades
Message-ID: <20090303152016.GE20120@sgi.com>
References: <20090303151044.GA20016@sgi.com> <20090303151357.GA20120@sgi.com> <20090303151524.GB20120@sgi.com> <20090303151657.GC20120@sgi.com> <20090303151827.GD20120@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090303151827.GD20120@sgi.com>
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
--- linux.orig/arch/x86/include/asm/uv/uv_hub.h	2009-03-02 08:20:20.000000000 -0600
+++ linux/arch/x86/include/asm/uv/uv_hub.h	2009-03-02 08:20:57.000000000 -0600
@@ -179,6 +179,10 @@ DECLARE_PER_CPU(struct uv_hub_info_s, __
 #define LOCAL_BUS_BASE		0x1c00000
 #define LOCAL_BUS_SIZE		(4 * 1024 * 1024)
 
+/* Loop through all installed blades */
+#define for_each_possible_blade(bid)                    \
+	for ((bid) = 0; (bid) < uv_num_possible_blades(); (bid)++)
+
 /*
  * System Controller Interface Reg
  *
