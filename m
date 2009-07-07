Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZGGKA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZGGKA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 06:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753976AbZGGKAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 06:00:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:58858 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939AbZGGKAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 06:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EmGrpUOMecJEqj95egY1cjWK1noBuFeiGLPHdh48oi7KF76JFzisffDgKGf6dz8xrC
         GE1Z8C51EMJ18cyOCcY5F3nlhPxqpacbr7GnzFddpkZb/JduFdfwYE5rxSsiWPDLxrlr
         zJIXsa97xgiflb8KiKOAwqB0O3ESgwtNn50f8=
Subject: [PATCH] vmalloc.c: fix vmap_page_range() return
From: "Figo.zhang" <figo1802@gmail.com>
To: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 18:00:49 +0800
Message-Id: <1246960849.2581.29.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


vmap_page_range() would never return a positive number.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
--- 
mm/vmalloc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f8189a4..bbd312d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1109,10 +1109,6 @@ int map_vm_area(struct vm_struct *area, pgprot_t prot, struct page ***pages)
 	int err;
 
 	err = vmap_page_range(addr, end, prot, *pages);
-	if (err > 0) {
-		*pages += err;
-		err = 0;
-	}
 
 	return err;
 }


