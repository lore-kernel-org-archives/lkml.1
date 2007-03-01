Return-Path: <linux-kernel-owner+w=401wt.eu-S932725AbXCAHJb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932725AbXCAHJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 02:09:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932739AbXCAHJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 02:09:31 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:57997 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932725AbXCAHJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 02:09:30 -0500
Date: Thu, 1 Mar 2007 02:04:23 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [PATCH] linux-kernel-markers-kconfig-menus-fix-5
Message-ID: <20070301070423.GA19339@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 01:59:24 up 26 days, 21:07,  5 users,  load average: 1.19, 1.17, 1.11
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux-kernel-markers-kconfig-menus-fix-5

- Change CONFIG_MARKERS_ENABLE_OPTIMIZATION for
  CONFIG_MARKERS_DISABLE_OPTIMIZATION.
- Have CONFIG_MARKERS_DISABLE_OPTIMIZATION depend on EMBEDDED.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

--- a/kernel/Kconfig.marker
+++ b/kernel/Kconfig.marker
@@ -7,10 +7,14 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
-config MARKERS_ENABLE_OPTIMIZATION
-	bool "Enable marker optimization"
-	depends on MARKERS
-	default y
+config MARKERS_DISABLE_OPTIMIZATION
+	bool "Disable marker optimization"
+	depends on MARKERS && EMBEDDED
+	default n
 	help
 	  Disable code replacement jump optimisations. Especially useful if your
 	  code is in a read-only rom/flash.
+
+config MARKERS_ENABLE_OPTIMIZATION
+	def_bool y
+	depends on MARKERS && !MARKERS_DISABLE_OPTIMIZATION
-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
