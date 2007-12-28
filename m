Return-Path: <linux-kernel-owner+w=401wt.eu-S1755599AbXL1TRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755599AbXL1TRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:17:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbXL1TRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:17:25 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:45083 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbXL1TRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:17:22 -0500
X-Greylist: delayed 1234 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Dec 2007 14:17:21 EST
Date: Fri, 28 Dec 2007 20:56:36 +0200
From: Adrian Bunk <adrian.bunk@movial.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Randy Dunlap <randy.dunlap@oracle.com>, rmk@arm.linux.org.uk,
       phil.el@wanadoo.fr
Cc: oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [2.6.24 patch] restore ARMv6 OProfile support
Message-ID: <20071228185636.GA4738@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch restores the ARMv6 OProfile support that was killed by
commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.

Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

---

 kernel/Kconfig.instrumentation |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

7fc221ef169610b5eac98e2ddd641811c0d53e4a 
diff --git a/kernel/Kconfig.instrumentation b/kernel/Kconfig.instrumentation
index 468f47a..4453187 100644
--- a/kernel/Kconfig.instrumentation
+++ b/kernel/Kconfig.instrumentation
@@ -29,2 +29,17 @@ config OPROFILE

+config OPROFILE_ARMV6
+	bool
+	depends on OPROFILE && ARM && CPU_V6 && !SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_MPCORE
+	bool
+	depends on OPROFILE && ARM && CPU_V6 && SMP
+	default y
+	select OPROFILE_ARM11_CORE
+
+config OPROFILE_ARM11_CORE
+	bool
+
 config KPROBES
