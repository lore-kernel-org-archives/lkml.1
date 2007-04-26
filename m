Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbXDZGEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbXDZGEU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXDZGEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:04:20 -0400
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:57204 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748AbXDZGET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:04:19 -0400
Date: Thu, 26 Apr 2007 02:04:17 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 02/12] NetLabel: convert a BUG_ON in the CIPSO code to a
 runtime check
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260203430.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

This patch changes a BUG_ON in the CIPSO code to a runtime check.  It should
also increase the readability of the code as it replaces an unexplained
constant with a well defined macro.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 net/ipv4/cipso_ipv4.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index d466bd5..6afc398 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -1142,7 +1142,9 @@ static int cipso_v4_map_cat_rng_hton(const struct cipso_v4_doi *doi_def,
 	u32 cat_size = 0;
 
 	/* make sure we don't overflow the 'array[]' variable */
-	BUG_ON(net_cat_len > 30);
+	if (net_cat_len >
+	    (CIPSO_V4_OPT_LEN_MAX - CIPSO_V4_HDR_LEN - CIPSO_V4_TAG_RNG_BLEN))
+		return -ENOSPC;
 
 	for (;;) {
 		iter = netlbl_secattr_catmap_walk(secattr->mls_cat, iter + 1);
-- 
1.5.0.6

