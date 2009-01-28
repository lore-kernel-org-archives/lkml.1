Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbZA1UgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbZA1UgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbZA1U3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:29:34 -0500
Received: from utopia.booyaka.com ([72.9.107.138]:32939 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbZA1U3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:29:30 -0500
MBOX-Line: From nobody Wed Jan 28 12:28:04 2009
From: Paul Walmsley <paul@pwsan.com>
Subject: [PATCH E 13/14] OMAP2/3 clock: remove clk->owner
To: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Date: Wed, 28 Jan 2009 12:28:04 -0700
Message-ID: <20090128192801.29333.48045.stgit@localhost.localdomain>
In-Reply-To: <20090128192551.29333.82943.stgit@localhost.localdomain>
References: <20090128192551.29333.82943.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3.222.gddca
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk@dyn-67.arm.linux.org.uk>

clk->owner is always NULL, so its existence doesn't serve any useful
function other than bloating the kernel by 992 bytes.  Remove it.

linux-omap source commit is 59ae1e06b177e462d75586d83380f18a7024e77b.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/clock.c              |    7 ++-----
 arch/arm/plat-omap/include/mach/clock.h |    1 -
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/plat-omap/clock.c b/arch/arm/plat-omap/clock.c
index 8417d11..2a4819f 100644
--- a/arch/arm/plat-omap/clock.c
+++ b/arch/arm/plat-omap/clock.c
@@ -191,15 +191,14 @@ struct clk * clk_get(struct device *dev, const char *id)
 	mutex_lock(&clocks_mutex);
 
 	list_for_each_entry(p, &clocks, node) {
-		if (p->id == idno &&
-		    strcmp(id, p->name) == 0 && try_module_get(p->owner)) {
+		if (p->id == idno && strcmp(id, p->name) == 0) {
 			clk = p;
 			goto found;
 		}
 	}
 
 	list_for_each_entry(p, &clocks, node) {
-		if (strcmp(id, p->name) == 0 && try_module_get(p->owner)) {
+		if (strcmp(id, p->name) == 0) {
 			clk = p;
 			break;
 		}
@@ -295,8 +294,6 @@ EXPORT_SYMBOL(clk_get_rate);
 
 void clk_put(struct clk *clk)
 {
-	if (clk && !IS_ERR(clk))
-		module_put(clk->owner);
 }
 EXPORT_SYMBOL(clk_put);
 
diff --git a/arch/arm/plat-omap/include/mach/clock.h b/arch/arm/plat-omap/include/mach/clock.h
index a039832..58450a1 100644
--- a/arch/arm/plat-omap/include/mach/clock.h
+++ b/arch/arm/plat-omap/include/mach/clock.h
@@ -77,7 +77,6 @@ struct clk_child {
 
 struct clk {
 	struct list_head	node;
-	struct module		*owner;
 	const char		*name;
 	int			id;
 	struct clk		*parent;


