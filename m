Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXDWXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXDWXG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 19:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXDWXGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 19:06:55 -0400
Received: from 61.sub-75-208-107.myvzw.com ([75.208.107.61]:38832 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476AbXDWXGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 19:06:54 -0400
X-Greylist: delayed 2185 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 19:06:53 EDT
Message-Id: <20070423215709.990824532@goop.org>
References: <20070423215638.563901986@goop.org>
User-Agent: quilt/0.46-1
Date: Mon, 23 Apr 2007 14:56:42 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 04/25] xen: Add XEN config options
Content-Disposition: inline; filename=xen-config.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The XEN config option enables the Xen paravirt_ops interface, which is
installed when the kernel finds itself running under Xen.

Xen is no longer a sub-architecture, so the X86_XEN subarch config
option has gone.

Xen is currently incompatible with PREEMPT, but this is fixed up later
in the series.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Ian Pratt <ian.pratt@xensource.com>
Signed-off-by: Christian Limpach <Christian.Limpach@cl.cam.ac.uk>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 arch/i386/Kconfig     |    2 ++
 arch/i386/xen/Kconfig |   10 ++++++++++
 2 files changed, 12 insertions(+)

===================================================================
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -216,6 +216,8 @@ config PARAVIRT
 	  under a hypervisor, improving performance significantly.
 	  However, when run without a hypervisor the kernel is
 	  theoretically slower.  If in doubt, say N.
+
+source "arch/i386/xen/Kconfig"
 
 config VMI
 	bool "VMI Paravirt-ops support"
===================================================================
--- /dev/null
+++ b/arch/i386/xen/Kconfig
@@ -0,0 +1,10 @@
+#
+# This Kconfig describes xen options
+#
+
+config XEN
+	bool "Enable support for Xen hypervisor"
+	depends on PARAVIRT && HZ_100 && !PREEMPT && !NO_HZ
+	default y
+	help
+	  This is the Linux Xen port.

-- 

