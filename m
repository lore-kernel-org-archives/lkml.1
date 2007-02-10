Return-Path: <linux-kernel-owner+w=401wt.eu-S964978AbXBLS7i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbXBLS7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 13:59:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965313AbXBLS7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 13:59:38 -0500
Received: from mbox.ssc.unict.it ([151.97.230.9]:42637 "EHLO ssc.unict.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964978AbXBLS7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 13:59:37 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 13:59:36 EST
From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>
To: Andrew Morton <akpm@osdl.org>, stable@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled.
Date: Sat, 10 Feb 2007 17:45:37 +0100
Message-Id: <11711259371905-git-send-email-blaisorblade@yahoo.it>
X-Mailer: git-send-email 1.4.4.4.ga596b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There is no prompt for STACKTRACE, so it is enabled only when 'select'ed.
FAULT_INJECTION depends on it, while LOCKDEP selects it. So FAULT_INJECTION
becomes visible in Kconfig only when LOCKDEP is enabled.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Index: linux-2.6.git/lib/Kconfig.debug
===================================================================
--- linux-2.6.git.orig/lib/Kconfig.debug
+++ linux-2.6.git/lib/Kconfig.debug
@@ -400,7 +400,7 @@ config LKDTM
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
-	depends on STACKTRACE
+	select STACKTRACE
 	select FRAME_POINTER
 	help
 	  Provide fault-injection framework.
