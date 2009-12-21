Return-Path: <linux-kernel-owner+w=401wt.eu-S1756569AbZLUBYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbZLUBYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 20:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZLUBYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 20:24:50 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58877 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbZLUBYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 20:24:49 -0500
Date: Mon, 21 Dec 2009 02:24:47 +0100
From: Andi Kleen <andi@firstfloor.org>
To: airlied@linux.ie, linux-kernel@vger.kernel.org
Subject: [PATCH] DRM: Rename clamp variable
Message-ID: <20091221012447.GA24782@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DRM: Rename clamp variable

linux/kernel.h has a "clamp" macro, but r300_cmdbuf also uses a variable
with the same name. Right now it doesn't seem to include the header,
but sooner or later someone will. So better rename the variable
now.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpu/drm/radeon/r300_cmdbuf.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.33-rc1-ak/drivers/gpu/drm/radeon/r300_cmdbuf.c
===================================================================
--- linux-2.6.33-rc1-ak.orig/drivers/gpu/drm/radeon/r300_cmdbuf.c
+++ linux-2.6.33-rc1-ak/drivers/gpu/drm/radeon/r300_cmdbuf.c
@@ -990,7 +990,7 @@ static inline int r300_emit_r500fp(drm_r
 	int sz;
 	int addr;
 	int type;
-	int clamp;
+	int isclamp;
 	int stride;
 	RING_LOCALS;
 
@@ -999,10 +999,10 @@ static inline int r300_emit_r500fp(drm_r
 	addr = ((header.r500fp.adrhi_flags & 1) << 8) | header.r500fp.adrlo;
 
 	type = !!(header.r500fp.adrhi_flags & R500FP_CONSTANT_TYPE);
-	clamp = !!(header.r500fp.adrhi_flags & R500FP_CONSTANT_CLAMP);
+	isclamp = !!(header.r500fp.adrhi_flags & R500FP_CONSTANT_CLAMP);
 
 	addr |= (type << 16);
-	addr |= (clamp << 17);
+	addr |= (isclamp << 17);
 
 	stride = type ? 4 : 6;
 
