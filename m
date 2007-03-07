Return-Path: <linux-kernel-owner+w=401wt.eu-S1422784AbXCGROv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422784AbXCGROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422791AbXCGROu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:50 -0500
Received: from mail.suse.de ([195.135.220.2]:43617 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422784AbXCGROY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:24 -0500
Message-Id: <20070307171247.038163039@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:02 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Paolo Blaisorblade Giarrusso <blaisorblade@yahoo.it>
Subject: [patch 027/101] Kconfig: FAULT_INJECTION can be selected only if LOCKDEP is enabled.
Content-Disposition: inline; filename=kconfig-fault_injection-can-be-selected-only-if-lockdep-is-enabled.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paolo 'Blaisorblade' Giarrusso" <blaisorblade@yahoo.it>

There is no prompt for STACKTRACE, so it is enabled only when 'select'ed.
FAULT_INJECTION depends on it, while LOCKDEP selects it. So FAULT_INJECTION
becomes visible in Kconfig only when LOCKDEP is enabled.

Signed-off-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.20.1.orig/lib/Kconfig.debug
+++ linux-2.6.20.1/lib/Kconfig.debug
@@ -400,7 +400,7 @@ config LKDTM
 config FAULT_INJECTION
 	bool "Fault-injection framework"
 	depends on DEBUG_KERNEL
-	depends on STACKTRACE
+	select STACKTRACE
 	select FRAME_POINTER
 	help
 	  Provide fault-injection framework.

--
