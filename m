Return-Path: <linux-kernel-owner+w=401wt.eu-S1756028AbZCFPgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028AbZCFPgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 10:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbZCFPgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 10:36:33 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:10315 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZCFPgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 10:36:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LfSNVTr1kavIz1v7QQVptgGRGz7p6mwhcJEyOlhP6uRdIwLsWSegoWvtoJHz+pOuJd
         H0xSM9GBTwUoElylXi8LeJMorD2sCmgO+JKKkk8tE/kM8WxXFAMIWlrkXutGyPbp3BIq
         D2cw1f9Od2IxB8b61JNVCGe0A6jxWoITpIADI=
Date: Sat, 7 Mar 2009 00:36:21 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <cl@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] slub: use get_track()
Message-ID: <20090306153620.GA6915@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_track() in set_track()

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 mm/slub.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

Index: 2.6-poison/mm/slub.c
===================================================================
--- 2.6-poison.orig/mm/slub.c
+++ 2.6-poison/mm/slub.c
@@ -374,14 +374,8 @@ static struct track *get_track(struct km
 static void set_track(struct kmem_cache *s, void *object,
 			enum track_item alloc, unsigned long addr)
 {
-	struct track *p;
+	struct track *p = get_track(s, object, alloc);
 
-	if (s->offset)
-		p = object + s->offset + sizeof(void *);
-	else
-		p = object + s->inuse;
-
-	p += alloc;
 	if (addr) {
 		p->addr = addr;
 		p->cpu = smp_processor_id();
