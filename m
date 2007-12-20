Return-Path: <linux-kernel-owner+w=401wt.eu-S1762885AbXLTWRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762885AbXLTWRM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbXLTWQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:16:04 -0500
Received: from baron.miniblade.com ([65.14.39.133]:28904 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764771AbXLTWQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:16:00 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 04/13] clean up udev configuration example
Date: Thu, 20 Dec 2007 17:15:52 -0500
Message-Id: <1198188961-25147-4-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
References: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a known default location for the udev configuration
file and uses the more recent "==" syntax for SUBSYSTEM and KERNEL.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 Documentation/aoe/udev-install.sh |    5 ++++-
 Documentation/aoe/udev.txt        |   15 ++++++++-------
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/Documentation/aoe/udev-install.sh b/Documentation/aoe/udev-install.sh
index 6449911..15e86f5 100644
--- a/Documentation/aoe/udev-install.sh
+++ b/Documentation/aoe/udev-install.sh
@@ -23,7 +23,10 @@ fi
 # /etc/udev/rules.d
 #
 rules_d="`sed -n '/^udev_rules=/{ s!udev_rules=!!; s!\"!!g; p; }' $conf`"
-if test -z "$rules_d" || test ! -d "$rules_d"; then
+if test -z "$rules_d" ; then
+	rules_d=/etc/udev/rules.d
+fi
+if test ! -d "$rules_d"; then
 	echo "$me Error: cannot find udev rules directory" 1>&2
 	exit 1
 fi
diff --git a/Documentation/aoe/udev.txt b/Documentation/aoe/udev.txt
index a7ed1dc..17e76c4 100644
--- a/Documentation/aoe/udev.txt
+++ b/Documentation/aoe/udev.txt
@@ -1,6 +1,7 @@
 # These rules tell udev what device nodes to create for aoe support.
-# They may be installed along the following lines (adjusted to what
-# you see on your system).
+# They may be installed along the following lines.  Check the section
+# 8 udev manpage to see whether your udev supports SUBSYSTEM, and
+# whether it uses one or two equal signs for SUBSYSTEM and KERNEL.
 # 
 #   ecashin@makki ~$ su
 #   Password:
@@ -15,10 +16,10 @@
 #  
 
 # aoe char devices
-SUBSYSTEM="aoe", KERNEL="discover",	NAME="etherd/%k", GROUP="disk", MODE="0220"
-SUBSYSTEM="aoe", KERNEL="err",		NAME="etherd/%k", GROUP="disk", MODE="0440"
-SUBSYSTEM="aoe", KERNEL="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="0220"
-SUBSYSTEM="aoe", KERNEL="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="discover",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="err",	NAME="etherd/%k", GROUP="disk", MODE="0440"
+SUBSYSTEM=="aoe", KERNEL=="interfaces",	NAME="etherd/%k", GROUP="disk", MODE="0220"
+SUBSYSTEM=="aoe", KERNEL=="revalidate",	NAME="etherd/%k", GROUP="disk", MODE="0220"
 
 # aoe block devices     
-KERNEL="etherd*",       NAME="%k", GROUP="disk"
+KERNEL=="etherd*",       NAME="%k", GROUP="disk"
-- 
1.5.3.4

