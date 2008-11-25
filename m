Return-Path: <linux-kernel-owner+w=401wt.eu-S1752876AbYKYNOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbYKYNOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 08:14:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbYKYNOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 08:14:36 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:34101 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYKYNOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 08:14:35 -0500
Date: Tue, 25 Nov 2008 14:14:32 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 3/5] fs/9p: change simple_strtol to simple_strtoul
Message-ID: <Pine.LNX.4.64.0811251413050.11897@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Since v9ses->uid is unsigned, it would seem better to use simple_strtoul that
simple_strtol.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r2@
long e;
position p;
@@

e = simple_strtol@p(...)

@@
position p != r2.p;
type T;
T e;
@@

e = 
- simple_strtol@p
+ simple_strtoul
  (...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 fs/9p/v9fs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/fs/9p/v9fs.c b/fs/9p/v9fs.c
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -160,7 +160,7 @@ static int v9fs_parse_options(struct v9f
 				v9ses->flags |= V9FS_ACCESS_ANY;
 			else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
-				v9ses->uid = simple_strtol(s, &e, 10);
+				v9ses->uid = simple_strtoul(s, &e, 10);
 				if (*e != '\0')
 					v9ses->uid = ~0;
 			}
