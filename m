Return-Path: <linux-kernel-owner+w=401wt.eu-S1755461AbZBNVS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbZBNVS1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbZBNVPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:15:23 -0500
Received: from mu-out-0910.google.com ([209.85.134.187]:33439 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196AbZBNVPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:15:21 -0500
From: Hannes Eder <hannes@hanneseder.net>
Subject: [PATCH 13/43] drivers/net/atlx: fix sparse warnings: fix signedness
To: netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 14 Feb 2009 22:15:17 +0100
Message-ID: <20090214211508.23489.57841.stgit@vmbox.hanneseder.net>
In-Reply-To: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
References: <20090214210940.23489.95001.stgit@vmbox.hanneseder.net>
User-Agent: StGit/0.14.3.348.gcb02
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: While being at it: statics do not need to be initialized with 0.

Fix this sparse warnings:
  drivers/net/atlx/atl1.c:109:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atlx/atl2.c:2870:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atlx/atl2.c:2880:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atlx/atl2.c:2894:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atlx/atl2.c:2904:1: warning: incorrect type in initializer (different signedness)
  drivers/net/atlx/atl2.c:2913:1: warning: incorrect type in initializer (different signedness)

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/net/atlx/atl1.c |    2 +-
 drivers/net/atlx/atl2.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index c0ceee0..43fc1b2 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -105,7 +105,7 @@
  * Default Value: 100 (200us)
  */
 static int __devinitdata int_mod_timer[ATL1_MAX_NIC+1] = ATL1_PARAM_INIT;
-static int num_int_mod_timer;
+static unsigned int num_int_mod_timer;
 module_param_array_named(int_mod_timer, int_mod_timer, int,
 	&num_int_mod_timer, 0);
 MODULE_PARM_DESC(int_mod_timer, "Interrupt moderator timer");
diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index bc39449..9fe06c3 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -2854,7 +2854,7 @@ static void atl2_force_ps(struct atl2_hw *hw)
 #else
 #define ATL2_PARAM(X, desc) \
     static int __devinitdata X[ATL2_MAX_NIC+1] = ATL2_PARAM_INIT; \
-    static int num_##X = 0; \
+    static unsigned int num_##X; \
     module_param_array_named(X, X, int, &num_##X, 0); \
     MODULE_PARM_DESC(X, desc);
 #endif

