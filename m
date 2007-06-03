Return-Path: <linux-kernel-owner+w=401wt.eu-S1752853AbXFCUq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbXFCUq3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 16:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbXFCUpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 16:45:44 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:55884 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbXFCUpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 16:45:43 -0400
Date: Sun, 3 Jun 2007 22:46:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net
Subject: [PATCH 07/19] kbuild: avoid environment to set variables used by kbuild
Message-ID: <20070603204644.GG9240@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 07/19] kbuild: avoid environment to set variables used by kbuild
From: Sam Ravnborg <sam@ravnborg.org>
Date: Mon, 28 May 2007 22:47:48 +0200

A few of the variables used by kbuild has fixed naming.
Make sure we do not pick up random values from the environment.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Makefile.build |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a525112..3f7b451 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -7,6 +7,22 @@ src := $(obj)
 PHONY := __build
 __build:
 
+# Init all relevant variables used in kbuild files so
+# 1) they have correct type
+# 2) they do not inherit any value from the environment
+obj-y :=
+obj-m :=
+lib-y :=
+lib-m :=
+always :=
+targets :=
+subdir-y :=
+subdir-m :=
+EXTRA_AFLAGS   :=
+EXTRA_CFLAGS   :=
+EXTRA_CPPFLAGS :=
+EXTRA_LDFLAGS  :=
+
 # Read .config if it exist, otherwise ignore
 -include include/config/auto.conf
 
-- 
1.5.1.rc3.1544.g8a923


----- End forwarded message -----
