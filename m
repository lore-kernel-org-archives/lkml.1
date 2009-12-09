Return-Path: <linux-kernel-owner+w=401wt.eu-S1757350AbZLITXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350AbZLITXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:23:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZLITXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:23:07 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:52702 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbZLITXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:23:04 -0500
Date: Wed, 9 Dec 2009 20:23:09 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/12] crypto: Correct size given to memset
Message-ID: <Pine.LNX.4.64.0912092022500.1870@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Memset should be given the size of the structure, not the size of the pointer.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
T *x;
expression E;
@@

memset(x, E, sizeof(
+ *
 x))
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 crypto/gf128mul.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -u -p a/crypto/gf128mul.c b/crypto/gf128mul.c
--- a/crypto/gf128mul.c
+++ b/crypto/gf128mul.c
@@ -182,7 +182,7 @@ void gf128mul_lle(be128 *r, const be128 
 	for (i = 0; i < 7; ++i)
 		gf128mul_x_lle(&p[i + 1], &p[i]);
 
-	memset(r, 0, sizeof(r));
+	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[15 - i];
 
@@ -220,7 +220,7 @@ void gf128mul_bbe(be128 *r, const be128 
 	for (i = 0; i < 7; ++i)
 		gf128mul_x_bbe(&p[i + 1], &p[i]);
 
-	memset(r, 0, sizeof(r));
+	memset(r, 0, sizeof(*r));
 	for (i = 0;;) {
 		u8 ch = ((u8 *)b)[i];
 
