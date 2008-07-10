Return-Path: <linux-kernel-owner+w=401wt.eu-S1759677AbYGJP2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759677AbYGJP2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 11:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759186AbYGJP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 11:27:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45151 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759181AbYGJP1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 11:27:07 -0400
Subject: [PATCH 11/15] regulator: documentation - regulator driver
From: Liam Girdwood <lg@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       arm kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 16:27:06 +0100
Message-Id: <1215703626.13431.67.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
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



