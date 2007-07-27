Return-Path: <linux-kernel-owner+w=401wt.eu-S936744AbXG0Jr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936744AbXG0Jr5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 05:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936274AbXG0JqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 05:46:12 -0400
Received: from sicnat3.emn.fr ([193.54.76.194]:35912 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933603AbXG0JqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 05:46:10 -0400
Date: Fri, 27 Jul 2007 11:44:42 +0200 (MEST)
Message-Id: <200707270944.LAA17193@ifs.emn.fr>
To: kernel-janitors@vger.kernel.org
Subject: [PATCH 07/68] 0 -> NULL, for arch/ia64
Cc: tony.luck@intel.com, linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
From: Yoann Padioleau <padator@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When comparing a pointer, it's clearer to compare it to NULL than to 0.

Here is an excerpt of the semantic patch: 

@@
expression *E;
@@

  E ==
- 0
+ NULL

@@
expression *E;
@@

  E !=
- 0
+ NULL

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr>
Cc: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org
Cc: akpm@linux-foundation.org
---

 simscsi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index bb87682..64248b5 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -101,7 +101,7 @@ simscsi_interrupt (unsigned long val)
 {
 	struct scsi_cmnd *sc;
 
-	while ((sc = queue[rd].sc) != 0) {
+	while ((sc = queue[rd].sc) != NULL) {
 		atomic_dec(&num_reqs);
 		queue[rd].sc = NULL;
 		if (DBG)

