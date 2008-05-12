Return-Path: <linux-kernel-owner+w=401wt.eu-S1759707AbYELKcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759707AbYELKcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760649AbYELKcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:32:13 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:51661 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760459AbYELKcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:32:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:sender;
        b=FnWSmsVMI7Rdngr97sJ4n2/XkZlu2DRV/duOrkQJdR6EIjr3svbG5D/6ViQx3wKTDSal9EPSCbN31ll04SiF/G5dj91fP3J2a3y86Kr6l6OlEU1+XyY2u8WmX9DbBgT/aXIGX19mH5JFqjitSVdDXLnLNPU4USR5Epx8mEmAPJs=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/4] [mm] buddy page allocator: add tunable big order allocation
Date: Mon, 12 May 2008 18:32:02 +0800
Message-Id: <1210588325-11027-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 init/Kconfig    |    9 +++++++++
 mm/page_alloc.c |    2 +-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 6135d07..b6ff75b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -742,6 +742,15 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config BIG_ORDER_ALLOC_NOFAIL_MAGIC
+	int "Big Order Allocation No FAIL Magic"
+	depends on EMBEDDED
+	range 3 10
+	default 3
+	help
+	  Let big-order allocations loop until memory gets free. Specified Value
+	  expresses the order.
+
 choice
 	prompt "Choose SLAB allocator"
 	default SLUB
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bdd5c43..71b09b4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1631,7 +1631,7 @@ nofail_alloc:
 	pages_reclaimed += did_some_progress;
 	do_retry = 0;
 	if (!(gfp_mask & __GFP_NORETRY)) {
-		if (order <= PAGE_ALLOC_COSTLY_ORDER) {
+		if (order <= CONFIG_BIG_ORDER_ALLOC_NOFAIL_MAGIC) {
 			do_retry = 1;
 		} else {
 			if (gfp_mask & __GFP_REPEAT &&
-- 
1.5.5

