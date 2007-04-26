Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbXDZGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbXDZGDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754752AbXDZGDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:03:33 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:53319 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbXDZGDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:03:32 -0400
Date: Thu, 26 Apr 2007 02:03:28 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 01/12] NetLabel: cleanup and document CIPSO constants
In-Reply-To: <Line.LNX.4.64.0704260200450.30059@d.namei>
Message-ID: <Line.LNX.4.64.0704260202340.30059@d.namei>
References: <Line.LNX.4.64.0704260200450.30059@d.namei>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Moore <paul.moore@hp.com>

This patch collects all of the CIPSO constants and puts them in one place; it
also documents each value explaining how the value is derived.

Signed-off-by: Paul Moore <paul.moore@hp.com>
Signed-off-by: James Morris <jmorris@namei.org>
---
 net/ipv4/cipso_ipv4.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index 2ce5b69..d466bd5 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -92,6 +92,33 @@ int cipso_v4_rbm_optfmt = 0;
 int cipso_v4_rbm_strictvalid = 1;
 
 /*
+ * Protocol Constants
+ */
+
+/* Maximum size of the CIPSO IP option, derived from the fact that the maximum
+ * IPv4 header size is 60 bytes and the base IPv4 header is 20 bytes long. */
+#define CIPSO_V4_OPT_LEN_MAX          40
+
+/* Length of the base CIPSO option, this includes the option type (1 byte), the
+ * option length (1 byte), and the DOI (4 bytes). */
+#define CIPSO_V4_HDR_LEN              6
+
+/* Base length of the restrictive category bitmap tag (tag #1). */
+#define CIPSO_V4_TAG_RBM_BLEN         4
+
+/* Base length of the enumerated category tag (tag #2). */
+#define CIPSO_V4_TAG_ENUM_BLEN        4
+
+/* Base length of the ranged categories bitmap tag (tag #5). */
+#define CIPSO_V4_TAG_RNG_BLEN         4
+/* The maximum number of category ranges permitted in the ranged category tag
+ * (tag #5).  You may note that the IETF draft states that the maximum number
+ * of category ranges is 7, but if the low end of the last category range is
+ * zero then it is possibile to fit 8 category ranges because the zero should
+ * be omitted. */
+#define CIPSO_V4_TAG_RNG_CAT_MAX      8
+
+/*
  * Helper Functions
  */
 
@@ -1109,15 +1136,12 @@ static int cipso_v4_map_cat_rng_hton(const struct cipso_v4_doi *doi_def,
 				     unsigned char *net_cat,
 				     u32 net_cat_len)
 {
-	/* The constant '16' is not random, it is the maximum number of
-	 * high/low category range pairs as permitted by the CIPSO draft based
-	 * on a maximum IPv4 header length of 60 bytes - the BUG_ON() assertion
-	 * does a sanity check to make sure we don't overflow the array. */
 	int iter = -1;
-	u16 array[16];
+	u16 array[CIPSO_V4_TAG_RNG_CAT_MAX * 2];
 	u32 array_cnt = 0;
 	u32 cat_size = 0;
 
+	/* make sure we don't overflow the 'array[]' variable */
 	BUG_ON(net_cat_len > 30);
 
 	for (;;) {
@@ -1196,9 +1220,6 @@ static int cipso_v4_map_cat_rng_ntoh(const struct cipso_v4_doi *doi_def,
  * Protocol Handling Functions
  */
 
-#define CIPSO_V4_OPT_LEN_MAX          40
-#define CIPSO_V4_HDR_LEN              6
-
 /**
  * cipso_v4_gentag_hdr - Generate a CIPSO option header
  * @doi_def: the DOI definition
-- 
1.5.0.6

