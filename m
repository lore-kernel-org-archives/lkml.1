Return-Path: <linux-kernel-owner+w=401wt.eu-S1753266AbYIQArB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266AbYIQArB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 20:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbYIQAqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 20:46:52 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:18630 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbYIQAqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 20:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:sender;
        b=EoOrdZizSywu7CIgYUeKmpOjSpPKrfGmFxSAc1hJEv23AhDCUhkQ5+GtKxS9CkJJ2n
         6D17unLfRvBPMfWKw32rKbNvITgvkVCOktXx9pT6OhH0YyfxbMMkz9eIuHLGSsyJtL1o
         AFFFHp8HnuUUtVWWrfyufjakSGPoDrD/h+fSU=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: jdike@addtoit.com, linux-kernel@vger.kernel.org
Cc: Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] uml: Make vde_user.c build again
Date: Tue, 16 Sep 2008 21:43:19 -0300
Message-Id: <1221612200-483-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.0.87.g2858d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 43f5b308 ("uml: fix build when SLOB is enabled") removed kmalloc()
from um_malloc.h, which breaks vde_user.c.

This patch fixes it by making vde_user.c call uml_kmalloc() instead of
kmalloc().

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---

This patch is against the Linus' current (as of about 5 minutes ago) tree.
Without this patch, it wouldn't build.

I've tested it by booting my uml image, connecting it to the internet using
vde_witch, and doing some network operations (some aptitude installs).

Thanks a lot,
		Alberto


 arch/um/drivers/vde_user.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/um/drivers/vde_user.c b/arch/um/drivers/vde_user.c
index 56533db..744eacf 100644
--- a/arch/um/drivers/vde_user.c
+++ b/arch/um/drivers/vde_user.c
@@ -78,7 +78,7 @@ void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
 {
 	struct vde_open_args *args;
 
-	vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
+	vpri->args = uml_kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
 	if (vpri->args == NULL) {
 		printk(UM_KERN_ERR "vde_init_libstuff - vde_open_args "
 		       "allocation failed");
-- 
1.6.0.87.g2858d

