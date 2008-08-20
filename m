Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbYHTT2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbYHTT2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYHTT0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:26:13 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48478 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302AbYHTT0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:26:12 -0400
Subject: [RFC v2][PATCH 9/9] remove ->cksum field
To: arnd@arndb.de
Cc: orenl@cs.columbia.edu, jeremy@goop.org,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Wed, 20 Aug 2008 12:26:08 -0700
References: <20080820192557.98788FAB@nimitz>
In-Reply-To: <20080820192557.98788FAB@nimitz>
Message-Id: <20080820192608.CEBC256B@nimitz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is unused so far.  We'll add it back later.

---

 oren-cr.git-dave/checkpoint/checkpoint.c |    2 --
 oren-cr.git-dave/checkpoint/ckpt_hdr.h   |    1 -
 oren-cr.git-dave/checkpoint/restart.c    |    3 +--
 3 files changed, 1 insertion(+), 5 deletions(-)

diff -puN checkpoint/checkpoint.c~remove-unused-cksum checkpoint/checkpoint.c
--- oren-cr.git/checkpoint/checkpoint.c~remove-unused-cksum	2008-08-20 12:12:51.000000000 -0700
+++ oren-cr.git-dave/checkpoint/checkpoint.c	2008-08-20 12:12:51.000000000 -0700
@@ -125,8 +125,6 @@ static int cr_write_tail(struct cr_ctx *
 	h.id = 0;
 
 	hh->magic = CR_HEADER_MAGIC;
-	hh->cksum[0] = 1;
-       	hh->cksum[1] = 1;	/* TBD ... */
 
 	ret = cr_write_obj(ctx, &h, hh);
 	kfree(hh);
diff -puN checkpoint/ckpt_hdr.h~remove-unused-cksum checkpoint/ckpt_hdr.h
--- oren-cr.git/checkpoint/ckpt_hdr.h~remove-unused-cksum	2008-08-20 12:12:51.000000000 -0700
+++ oren-cr.git-dave/checkpoint/ckpt_hdr.h	2008-08-20 12:12:51.000000000 -0700
@@ -43,7 +43,6 @@ struct cr_hdr_head {
 
 struct cr_hdr_tail {
 	__u32 magic;
-	__u32 cksum[2];
 };
 
 struct cr_hdr_task {
diff -puN checkpoint/restart.c~remove-unused-cksum checkpoint/restart.c
--- oren-cr.git/checkpoint/restart.c~remove-unused-cksum	2008-08-20 12:12:51.000000000 -0700
+++ oren-cr.git-dave/checkpoint/restart.c	2008-08-20 12:12:51.000000000 -0700
@@ -113,8 +113,7 @@ static int cr_read_tail(struct cr_ctx *c
 	if (ret < 0)
 		return ret;
 
-	if (hh->magic != CR_HEADER_MAGIC ||
-	    hh->cksum[0] != 1 || hh->cksum[1] != 1)
+	if (hh->magic != CR_HEADER_MAGIC)
 		return -EINVAL;
 
 	kfree(hh);
_
