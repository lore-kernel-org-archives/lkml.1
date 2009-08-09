Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbZHIT4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbZHIT4e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753146AbZHIT4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:56:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:23922 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbZHITy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:54:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=a2TYfwSDmRTeUpSJJtkmp11FtIs+SegdxLJtVSLsf6hAWNbmIME/KO3GjBCDxRtrfM
         //ctRvolMuilpEiBvh0gNx9l7PmOO+YtZUX6z1PeC49RVdFDTObEhxWf0NbLDvhaqg/N
         ajqCpBNherrPaQRzlRpURiAT4vdh+q0JWM/+E=
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 04/14] sh: use printk_once
Date: Sun,  9 Aug 2009 21:53:59 +0200
Message-Id: <1249847649-11631-5-git-send-email-marcin.slusarz@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
References: <1249847649-11631-1-git-send-email-marcin.slusarz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org
---
 arch/sh/mm/ioremap_64.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/arch/sh/mm/ioremap_64.c b/arch/sh/mm/ioremap_64.c
index 828c859..b16843d 100644
--- a/arch/sh/mm/ioremap_64.c
+++ b/arch/sh/mm/ioremap_64.c
@@ -94,7 +94,6 @@ static struct resource *shmedia_find_resource(struct resource *root,
 static void __iomem *shmedia_alloc_io(unsigned long phys, unsigned long size,
 				      const char *name, unsigned long flags)
 {
-	static int printed_full;
 	struct xresource *xres;
 	struct resource *res;
 	char *tack;
@@ -108,11 +107,8 @@ static void __iomem *shmedia_alloc_io(unsigned long phys, unsigned long size,
 		tack = xres->xname;
 		res = &xres->xres;
 	} else {
-		if (!printed_full) {
-			printk(KERN_NOTICE "%s: done with statics, "
+		printk_once(KERN_NOTICE "%s: done with statics, "
 			       "switching to kmalloc\n", __func__);
-			printed_full = 1;
-		}
 		tlen = strlen(name);
 		tack = kmalloc(sizeof(struct resource) + tlen + 1, GFP_KERNEL);
 		if (!tack)
-- 
1.6.3.3

