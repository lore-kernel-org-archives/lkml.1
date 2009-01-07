Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbZAHGS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbZAHGS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:18:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759234AbZAHGSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:18:15 -0500
Received: from 076-076-148-181.pdx.net ([76.76.148.181]:35230 "EHLO gocho"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755779AbZAHGSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:18:13 -0500
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 3/3] wimax: testing for rfkill support should also test for CONFIG_RFKILL_MODULE
Date: Wed,  7 Jan 2009 09:18:47 -0800
Message-Id: <ce4d7f71df1471d502e02861a7db65cbb2a5548f.1231348339.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1231348339.git.inaky@linux.intel.com>
References: <cover.1231348339.git.inaky@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current WiMAX rfkill code is missing the case where rfkill is compiled
in as modules and works only when rfkill is compiled in. This is not
correct. Fixed to test for CONFIG_RFKILL or CONFIG_RKILL_MODULE.

Signed-off-by: Inaky Perez-Gonzalez <inaky@linux.intel.com>
---
 net/wimax/op-rfkill.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wimax/op-rfkill.c b/net/wimax/op-rfkill.c
index 8745bac..2b75aee 100644
--- a/net/wimax/op-rfkill.c
+++ b/net/wimax/op-rfkill.c
@@ -71,7 +71,7 @@
 #define D_SUBMODULE op_rfkill
 #include "debug-levels.h"
 
-#ifdef CONFIG_RFKILL
+#if defined(CONFIG_RFKILL) || defined(CONFIG_RFKILL_MODULE)
 
 
 /**
-- 
1.5.6.5

