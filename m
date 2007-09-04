Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbXIDPAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbXIDPAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2007 11:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754699AbXIDPAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Sep 2007 11:00:22 -0400
Received: from ns2.suse.de ([195.135.220.15]:39585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660AbXIDPAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2007 11:00:20 -0400
Date: Tue, 4 Sep 2007 17:00:18 +0200
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Dan Aloni <da-x@monatomic.org>
Subject: [PATCH] Add ELF note with Linux version
Message-ID: <20070904150018.GA4357@suse.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Dan Aloni <da-x@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: SUSE LINUX Products GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds version information to the ELF kernel file. Together
with the bzImage version information, this allows distributions to
identify the kernel version based on the file name.


Signed-off-by: Dan Aloni <da-x@monatomic.org>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---
 include/linux/elfnote.h |    9 +++++++++
 init/version.c          |    3 +++
 2 files changed, 12 insertions(+)

--- a/include/linux/elfnote.h
+++ b/include/linux/elfnote.h
@@ -93,6 +93,15 @@
 
 #define ELFNOTE32(name, type, desc) ELFNOTE(32, name, type, desc)
 #define ELFNOTE64(name, type, desc) ELFNOTE(64, name, type, desc)
+
+#ifdef CONFIG_64BIT
+#define ELFNOTE_C(params...) ELFNOTE64(params)
+#else
+#define ELFNOTE_C(params...) ELFNOTE32(params)
+#endif
+
 #endif	/* __ASSEMBLER__ */
 
+#define LINUX_ELFNOTE_UTS_RELEASE    0
+
 #endif /* _LINUX_ELFNOTE_H */
--- a/init/version.c
+++ b/init/version.c
@@ -11,6 +11,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/utsrelease.h>
+#include <linux/elfnote.h>
 #include <linux/version.h>
 
 #define version(a) Version_ ## a
@@ -42,3 +43,5 @@ const char linux_proc_banner[] =
 	"%s version %s"
 	" (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ")"
 	" (" LINUX_COMPILER ") %s\n";
+
+ELFNOTE_C("LINUX", LINUX_ELFNOTE_UTS_RELEASE, UTS_RELEASE);
