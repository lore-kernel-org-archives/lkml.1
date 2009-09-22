Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbZIVQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbZIVQGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932335AbZIVQGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 12:06:22 -0400
Received: from s-utl01-sjpop.stsn.net ([72.254.0.201]:54683 "HELO
	s-utl01-sjpop.stsn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932331AbZIVQGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 12:06:21 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] regulator: Add some brief design documentation
Date: Tue, 22 Sep 2009 08:50:32 -0700
Message-Id: <1253634632-8398-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide some brief documentation of some of the design decisions that
are made by the regulator API.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/design.txt |   33 ++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/regulator/design.txt

diff --git a/Documentation/power/regulator/design.txt b/Documentation/power/regulator/design.txt
new file mode 100644
index 0000000..f9b56b7
--- /dev/null
+++ b/Documentation/power/regulator/design.txt
@@ -0,0 +1,33 @@
+Regulator API design notes
+==========================
+
+This document provides a brief, partially structured, overview of some
+of the design considerations which impact the regulator API design.
+
+Safety
+------
+
+ - Errors in regulator configuration can have very serious consequences
+   for the system, potentially including lasting hardware damage.
+ - It is not possible to automatically determine the power confugration
+   of the system - software-equivalent variants of the same chip may
+   have different power requirments, and not all components with power
+   requirements are visible to software.
+
+  => The API should make no changes to the hardware state unless it has
+     specific knowledge that these changes are safe to do perform on
+     this particular system.
+
+Consumer use cases
+------------------
+
+ - The overwhelming majority of devices in a system will have no
+   requirement to do any runtime configuration of their power beyond
+   being able to turn it on or off.
+
+ - Many of the power supplies in the system will be shared between many
+   different consumers.
+
+  => The consumer API should be structured so that these use cases are
+     very easy to handle and so that consumers will work with shared
+     supplies without any additional effort.
-- 
1.6.3.3


