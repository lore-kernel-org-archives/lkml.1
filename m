Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbYFCG5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbYFCG5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 02:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYFCG4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 02:56:52 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55138 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbYFCG4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 02:56:52 -0400
Message-Id: <20080603065712.322118000@bull.net>
References: <20080603065633.480505000@bull.net>
User-Agent: quilt/0.45-1
Date: Tue, 03 Jun 2008 08:56:34 +0200
From: Nadia.Derbey@bull.net
To: akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com
Cc: manfred@colorfullife.com, lnxninja@linux.vnet.ibm.com, efault@gmx.de,
       linux-kernel@vger.kernel.org, Nadia Derbey <Nadia.Derbey@bull.net>
Subject: [PATCH -mm1] Remove useless calls to INIT_RCU_HEAD in the idr code (was Scalability requirements for sysv ipc - v3)
Content-Disposition: inline; filename=remove_useless_init_rcu_head_from_idr_code.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since I didn't get any answer yesterday, (see http://lkml.org/lkml/2008/6/2/20)
here's the patch after Paul's review.


Regards,
Nadia

[ PATCH 01/01 ]

This is a trivial patch that removes unneeded calls to INIT_RCU_HEAD() in the
idr api code.

This patch applies to 2.6.26-rc2-mm1.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>

---
 lib/idr.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.26-rc2-mm1/lib/idr.c
===================================================================
--- linux-2.6.26-rc2-mm1.orig/lib/idr.c	2008-05-29 13:09:01.000000000 +0200
+++ linux-2.6.26-rc2-mm1/lib/idr.c	2008-06-02 09:32:46.000000000 +0200
@@ -185,7 +185,6 @@ static int sub_alloc(struct idr *idp, in
 			new = get_from_free_list(idp);
 			if (!new)
 				return -1;
-			INIT_RCU_HEAD(&new->rcu_head);
 			rcu_assign_pointer(p->ary[m], new);
 			p->count++;
 		}
@@ -211,7 +210,6 @@ build_up:
 	if (unlikely(!p)) {
 		if (!(p = get_from_free_list(idp)))
 			return -1;
-		INIT_RCU_HEAD(&p->rcu_head);
 		layers = 1;
 	}
 	/*
@@ -239,7 +237,6 @@ build_up:
 		}
 		new->ary[0] = p;
 		new->count = 1;
-		INIT_RCU_HEAD(&new->rcu_head);
 		if (p->bitmap == IDR_FULL)
 			__set_bit(0, &new->bitmap);
 		p = new;

--
