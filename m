Return-Path: <linux-kernel-owner+w=401wt.eu-S1422955AbXCGRTW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422955AbXCGRTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:19:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422942AbXCGRTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:19:09 -0500
Received: from ns.suse.de ([195.135.220.2]:44545 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422936AbXCGRSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:18:46 -0500
Message-Id: <20070307171708.189649726@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:12:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       mm-commits@vger.kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, yanmin.zhang@intel.com,
       yanmin_zhang@linux.intel.com, tony.luck@intel.com, jeff@garzik.org
Subject: [patch 100/101] ATA: convert GSI to irq on ia64
Content-Disposition: inline; filename=ata-convert-gsi-to-irq-on-ia64.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>

If an ATA drive uses legacy mode, ata driver will choose 14 and 15 as the
fixed irq number.  On ia64 platform, such numbers are GSI and should be
converted to irq vector.

Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/ia64/Kconfig                 |    1 +
 include/asm-ia64/libata-portmap.h |   12 ++++++++++++
 2 files changed, 13 insertions(+)

--- linux-2.6.20.1.orig/arch/ia64/Kconfig
+++ linux-2.6.20.1/arch/ia64/Kconfig
@@ -11,6 +11,7 @@ menu "Processor type and features"
 
 config IA64
 	bool
+	select ATA_NONSTANDARD if ATA
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
--- /dev/null
+++ linux-2.6.20.1/include/asm-ia64/libata-portmap.h
@@ -0,0 +1,12 @@
+#ifndef __ASM_IA64_LIBATA_PORTMAP_H
+#define __ASM_IA64_LIBATA_PORTMAP_H
+
+#define ATA_PRIMARY_CMD		0x1F0
+#define ATA_PRIMARY_CTL		0x3F6
+#define ATA_PRIMARY_IRQ(dev)	isa_irq_to_vector(14)
+
+#define ATA_SECONDARY_CMD	0x170
+#define ATA_SECONDARY_CTL	0x376
+#define ATA_SECONDARY_IRQ(dev)	isa_irq_to_vector(15)
+
+#endif

--
