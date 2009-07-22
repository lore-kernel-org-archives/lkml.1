Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbZGVDIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbZGVDIU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 23:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756066AbZGVDIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 23:08:19 -0400
Received: from dscas1.ad.uiuc.edu ([128.174.68.119]:4982 "EHLO
	dscas1.ad.uiuc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZGVDIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 23:08:18 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Jul 2009 23:08:17 EDT
From: Stoyan Gaydarov <sgayda2@uiuc.edu>
To: linux-kernel@vger.kernel.org
CC: Stoyan Gaydarov <sgayda2@uiuc.edu>, benh@kernel.crashing.org,
       paulus@samba.org, linuxppc-dev@ozlabs.org
Subject: [PATCH 5/7] [powerpc] ARRAY_SIZE changes
Date: Tue, 21 Jul 2009 22:02:31 -0500
Message-ID: <1248231753-8344-6-git-send-email-sgayda2@uiuc.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248231753-8344-5-git-send-email-sgayda2@uiuc.edu>
References: <1248231753-8344-1-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-2-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-3-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-4-git-send-email-sgayda2@uiuc.edu>
 <1248231753-8344-5-git-send-email-sgayda2@uiuc.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These changes were a direct result of using a semantic patch
More information can be found at http://www.emn.fr/x-info/coccinelle/

Signed-off-by: Stoyan Gaydarov <sgayda2@uiuc.edu>
---
 arch/powerpc/platforms/pasemi/idle.c      |    2 +-
 arch/powerpc/platforms/powermac/feature.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pasemi/idle.c b/arch/powerpc/platforms/pasemi/idle.c
index 43911d8..75b296b 100644
--- a/arch/powerpc/platforms/pasemi/idle.c
+++ b/arch/powerpc/platforms/pasemi/idle.c
@@ -90,7 +90,7 @@ machine_late_initcall(pasemi, pasemi_idle_init);
 static int __init idle_param(char *p)
 {
 	int i;
-	for (i = 0; i < sizeof(modes)/sizeof(struct sleep_mode); i++) {
+	for (i = 0; i < ARRAY_SIZE(modes); i++) {
 		if (!strcmp(modes[i].name, p)) {
 			current_mode = i;
 			break;
diff --git a/arch/powerpc/platforms/powermac/feature.c b/arch/powerpc/platforms/powermac/feature.c
index e6c0040..095de32 100644
--- a/arch/powerpc/platforms/powermac/feature.c
+++ b/arch/powerpc/platforms/powermac/feature.c
@@ -2419,13 +2419,13 @@ static int __init probe_motherboard(void)
 	dt = of_find_node_by_name(NULL, "device-tree");
 	if (dt != NULL)
 		model = of_get_property(dt, "model", NULL);
-	for(i=0; model && i<(sizeof(pmac_mb_defs)/sizeof(struct pmac_mb_def)); i++) {
+	for(i=0; model && i<ARRAY_SIZE(pmac_mb_defs); i++) {
 	    if (strcmp(model, pmac_mb_defs[i].model_string) == 0) {
 		pmac_mb = pmac_mb_defs[i];
 		goto found;
 	    }
 	}
-	for(i=0; i<(sizeof(pmac_mb_defs)/sizeof(struct pmac_mb_def)); i++) {
+	for(i=0; i<ARRAY_SIZE(pmac_mb_defs); i++) {
 	    if (machine_is_compatible(pmac_mb_defs[i].model_string)) {
 		pmac_mb = pmac_mb_defs[i];
 		goto found;
-- 
1.6.3.3

