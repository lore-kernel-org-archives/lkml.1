Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYLUPmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYLUPmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755692AbYLUPmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:42:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:59116 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755421AbYLUPmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:42:20 -0500
Date: Sun, 21 Dec 2008 16:42:18 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 13/13] net/appletalk: Remove redundant test
Message-ID: <Pine.LNX.4.64.0812211641590.9555@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

atif is tested for being NULL twice, with the same effect in each case.  I
have kept the second test, as it seems to fit well with the comment above it.

A simplified version of the semantic patch that makes this change is as
follows: (http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
expression E;
position p1,p2;
@@

if (x@p1 == NULL || ...) { ... when forall
   return ...; }
... when != \(x=E\|x--\|x++\|--x\|++x\|x-=E\|x+=E\|x|=E\|x&=E\|&x\)
(
x@p2 == NULL
|
x@p2 != NULL
)

// another path to the test that is not through p1?
@s exists@
local idexpression r.x;
position r.p1,r.p2;
@@

... when != x@p1
(
x@p2 == NULL
|
x@p2 != NULL
)

@fix depends on !s@
position r.p1,r.p2;
expression x,E;
statement S1,S2;
@@

(
- if ((x@p2 != NULL) || ...)
  S1
|
- if ((x@p2 == NULL) && ...) S1
|
- BUG_ON(x@p2 == NULL);
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 net/appletalk/ddp.c                 |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index c3f0027..5abce07 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -815,9 +815,6 @@ static int atif_ioctl(int cmd, void __user *arg)
 				return -EPERM;
 			if (sa->sat_family != AF_APPLETALK)
 				return -EINVAL;
-			if (!atif)
-				return -EADDRNOTAVAIL;
-
 			/*
 			 * for now, we only support proxy AARP on ELAP;
 			 * we should be able to do it for LocalTalk, too.
