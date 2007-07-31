Return-Path: <linux-kernel-owner+w=401wt.eu-S1761208AbXGaXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761208AbXGaXi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXGaXiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:38:50 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39961 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXGaXit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:38:49 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] clean Modules.symvers in external module dirs
Date: Tue, 31 Jul 2007 19:38:44 -0400
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311938.45116.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At the moment, running `make clean` in an external module directory does a
nice job of cleaning up with one exception: it leaves behind Modules.symvers.
Attached patch adds this file to the clean list for external modules.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/Makefile b/Makefile
index dfe3d16..1db97d6 100644
--- a/Makefile
+++ b/Makefile
@@ -1253,8 +1253,10 @@
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
 clean:	rm-dirs := $(MODVERDIR)
+clean: rm-files := Module.symvers
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
+	$(call cmd,rmfiles)
 	@find $(KBUILD_EXTMOD) $(RCS_FIND_IGNORE) \
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \) \
