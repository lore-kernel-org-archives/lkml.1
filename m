Return-Path: <linux-kernel-owner+w=401wt.eu-S1757186AbXLHNAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbXLHNAy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 08:00:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752418AbXLHNAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 08:00:46 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:63965 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXLHNAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 08:00:45 -0500
Date: Sat, 8 Dec 2007 13:56:35 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20071208125841.28121.8565.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] kernel/params.c: Remove sparse-warning (different signedness).
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing:
  CHECK   kernel/params.c
kernel/params.c:329:41: warning: incorrect type in argument 8 (different signedness)
kernel/params.c:329:41:    expected int *num
kernel/params.c:329:41:    got unsigned int *

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested on x86 with all[yes|mod|no]config.
Since 'num' is initialized to '0', then only increments, it can/should be unsigned.


diff --git a/kernel/params.c b/kernel/params.c
index 2a4c514..de1d0c4 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -272,7 +272,7 @@ static int param_array(const char *name,
 		       unsigned int min, unsigned int max,
 		       void *elem, int elemsize,
 		       int (*set)(const char *, struct kernel_param *kp),
-		       int *num)
+		       unsigned int *num)
 {
 	int ret;
 	struct kernel_param kp;
