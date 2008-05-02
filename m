Return-Path: <linux-kernel-owner+w=401wt.eu-S965042AbYEBPwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042AbYEBPwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 11:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933156AbYEBPvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 11:51:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38975 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756488AbYEBPvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 11:51:50 -0400
X-Greylist: delayed 667 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 May 2008 11:51:50 EDT
Subject: [PATCH 11/13] regulator: documentation - regulator driver
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Fri, 02 May 2008 16:44:02 +0100
Message-Id: <1209743042.12502.55.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds documentation describing the regulator driver interface.

Signed-off-by: Liam Girdwood <lg@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/regulator.txt |   30 +++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/power/regulator/regulator.txt

diff --git a/Documentation/power/regulator/regulator.txt b/Documentation/power/regulator/regulator.txt
new file mode 100644
index 0000000..a690501
--- /dev/null
+++ b/Documentation/power/regulator/regulator.txt
@@ -0,0 +1,30 @@
+Regulator Driver Interface
+==========================
+
+The regulator driver interface is relatively simple and designed to allow
+regulator drivers to register their services with the core framework.
+
+
+Registration
+============
+
+Drivers can register a regulator by calling :-
+
+struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
+					  void *reg_data);
+
+This will register the regulators capabilities and operations the regulator
+core. The core does not touch reg_data (private to regulator driver).
+
+Regulators can be unregistered by calling :-
+
+void regulator_unregister(struct regulator_dev *rdev);
+
+
+Regulator Events
+================
+Regulators can send events (e.g. over temp, under voltage, etc) to consumer
+drivers by calling :-
+
+int regulator_notifier_call_chain(struct regulator_dev *rdev,
+				  unsigned long event, void *data);
-- 
1.5.4.3


