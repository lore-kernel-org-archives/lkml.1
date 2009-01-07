Return-Path: <linux-kernel-owner+w=401wt.eu-S1761239AbZAGTYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761239AbZAGTYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757024AbZAGTWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:22:36 -0500
Received: from mga05.intel.com ([192.55.52.89]:34602 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756809AbZAGTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:22:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,339,1228118400"; 
   d="scan'208";a="655323915"
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: netdev@vger.kernel.org
Cc: wimax@linuxwimax.org, greg@kroah.com,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-wimax@intel.com
Subject: [PATCH 3/4] wimax: testing for rfkill support should also test for CONFIG_RFKILL_MODULE
Date: Wed,  7 Jan 2009 11:22:21 -0800
Message-Id: <ce4d7f71df1471d502e02861a7db65cbb2a5548f.1231355768.git.inaky@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <cover.1231355768.git.inaky@linux.intel.com>
References: <cover.1231355768.git.inaky@linux.intel.com>
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

