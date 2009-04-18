Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbZDRAzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbZDRAzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 20:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZDRAzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 20:55:11 -0400
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:47006 "HELO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751400AbZDRAzK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 20:55:10 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] mm/vmalloc.c: fix sparse warning
Date: Fri, 17 Apr 2009 20:55:06 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE1909015F9239@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mm/vmalloc.c: fix sparse warning
Thread-Index: Acm/wFCS3FopZ0JYRhWhf7elac5sow==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Apr 2009 00:55:07.0943 (UTC) FILETIME=[518A8B70:01C9BFC0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning in mm/vmalloc.c.

  warning: symbol 'tmp' shadows an earlier one

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fab1987..4959a30 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -292,13 +292,13 @@ static void __insert_vmap_area(struct vmap_area
*va)
 	struct rb_node *tmp;
 
 	while (*p) {
-		struct vmap_area *tmp;
+		struct vmap_area *tmp_va;
 
 		parent = *p;
-		tmp = rb_entry(parent, struct vmap_area, rb_node);
-		if (va->va_start < tmp->va_end)
+		tmp_va = rb_entry(parent, struct vmap_area, rb_node);
+		if (va->va_start < tmp_va->va_end)
 			p = &(*p)->rb_left;
-		else if (va->va_end > tmp->va_start)
+		else if (va->va_end > tmp_va->va_start)
 			p = &(*p)->rb_right;
 		else
 			BUG(); 
