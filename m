Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbXFZTFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbXFZTFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757453AbXFZTF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:28 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25143 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758058AbXFZTF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:26 -0400
Message-Id: <8e61d0fb50a2c8118be312460b648c5461749947.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:11 -0400
Subject: [PATCH 04/12] clean up udev configuration example
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
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
1.5.2.1

