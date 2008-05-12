Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYELNhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYELNhz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 09:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYELNhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 09:37:36 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:44109 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYELNhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 09:37:35 -0400
Date: Mon, 12 May 2008 15:37:31 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/6] drivers/md: remove null pointer dereference
Message-ID: <Pine.LNX.4.64.0805121537100.3694@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

If pgpath->pg->ps.type is NULL, it is not possible to access its name
field.  So I have simply modified the error message to drop the printing of
the name field.


This problem was found using the following semantic match
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

* if (E == NULL)
{
  ... when != if (E == NULL) S1 else S2
      when != E = E1
* E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

diff -u -p a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
--- a/drivers/md/dm-mpath.c	2008-04-16 13:27:57.000000000 +0200
+++ b/drivers/md/dm-mpath.c	2008-05-12 09:19:35.000000000 +0200
@@ -884,8 +884,7 @@ static int reinstate_path(struct pgpath 
 		goto out;
 
 	if (!pgpath->pg->ps.type) {
-		DMWARN("Reinstate path not supported by path selector %s",
-		       pgpath->pg->ps.type->name);
+		DMWARN("Reinstate path not supported by path selector");
 		r = -EINVAL;
 		goto out;
 	}
