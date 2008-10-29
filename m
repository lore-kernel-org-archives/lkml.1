Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbYJ2XDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbYJ2XDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 19:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbYJ2XCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 19:02:47 -0400
Received: from kroah.org ([198.145.64.141]:35888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759059AbYJ2XCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 19:02:00 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 1/6] Document kernel taint flags properly
Date: Wed, 29 Oct 2008 15:58:07 -0700
Message-Id: <1225321092-21933-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081029223824.GB21657@kroah.com>
References: <20081029223824.GB21657@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fills in the documentation for all of the current kernel taint
flags, and fixes the number for TAINT_CRAP, which was incorrectly
described.

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index bde799e..a4ccdd1 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -363,11 +363,21 @@ tainted:
 Non-zero if the kernel has been tainted.  Numeric values, which
 can be ORed together:
 
-  1 - A module with a non-GPL license has been loaded, this
-      includes modules with no license.
-      Set by modutils >= 2.4.9 and module-init-tools.
-  2 - A module was force loaded by insmod -f.
-      Set by modutils >= 2.4.9 and module-init-tools.
-  4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
- 64 - A module from drivers/staging was loaded.
+   1 - A module with a non-GPL license has been loaded, this
+       includes modules with no license.
+       Set by modutils >= 2.4.9 and module-init-tools.
+   2 - A module was force loaded by insmod -f.
+       Set by modutils >= 2.4.9 and module-init-tools.
+   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
+   8 - A module was forcibly unloaded from the system by rmmod -f.
+  16 - A hardware machine check error occurred on the system.
+  32 - A bad page was discovered on the system.
+  64 - The user has asked that the system be marked "tainted".  This
+       could be because they are running software that directly modifies
+       the hardware, or for other reasons.
+ 128 - The system has died.
+ 256 - The ACPI DSDT has been overridden with one supplied by the user
+        instead of using the one provided by the hardware.
+ 512 - A kernel warning has occurred.
+1024 - A module from drivers/staging was loaded.
 
-- 
1.6.0.2

