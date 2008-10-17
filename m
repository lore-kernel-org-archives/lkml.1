Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYJQW6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYJQW6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 18:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYJQW6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 18:58:33 -0400
Received: from kroah.org ([198.145.64.141]:50027 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752001AbYJQW6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 18:58:32 -0400
Date: Fri, 17 Oct 2008 15:55:15 -0700
From: Greg KH <greg@kroah.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>, linux-kernel@vger.kernel.org,
       linux-api@vger.kernel.org
Subject: [PATCH] Document kernel taint flags properly
Message-ID: <20081017225515.GA14133@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

This fills in the documentation for all of the current kernel taint
flags, and fixes the number for TAINT_CRAP, which was incorrectly
described.

Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 Documentation/sysctl/kernel.txt |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

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
+   8 - A module was forcefully unloaded from the system by rmmod -f.
+  16 - A hardware machine check error occured on the system.
+  32 - A bad page was discovered on the system.
+  64 - The user has asked that the system be marked "tainted".  This
+       could be because they are running software that directly modifies
+       the hardware, or for other reasons.
+ 128 - The system has died.
+ 256 - The ACPI DSDT has been overridden with one supplied by the user
+        instead of using the one provided by the hardware.
+ 512 - A kernel warning has occurred.
+1024 - A module from drivers/staging was loaded.
 
