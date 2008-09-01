Return-Path: <linux-kernel-owner+w=401wt.eu-S1752421AbYIANMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbYIANMu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 09:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751289AbYIANMn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 09:12:43 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:21578 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751246AbYIANMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 09:12:41 -0400
Message-ID: <48BBE9FC.9080702@panasas.com>
Date: Mon, 01 Sep 2008 16:11:24 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] net/niu: Fix none-const BUILD_BUG_ON usage
References: <48BBE77D.7070007@panasas.com>
In-Reply-To: <48BBE77D.7070007@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Sep 2008 13:10:36.0394 (UTC) FILETIME=[1F8D0CA0:01C90C34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It would be easy to constify the expression but I have removed
the BUILD_BUG_ON. (Left the useful comment though). Since
it has no point here, a BUILD_BUG_ON is used when two
inter-dependent but separate pieces of code must match. which
is not the case here.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: David S. Miller <davem@davemloft.net>
---
 drivers/net/niu.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index e4765b7..b517d0c 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -5135,17 +5135,15 @@ static void niu_init_tx_mac(struct niu *np)
 {
 	u64 min, max;
 
+	/* NOTE: XMAC_MIN register only accepts values for TX min which
+	 * have the low 3 bits cleared.
+	 */
 	min = 64;
 	if (np->dev->mtu > ETH_DATA_LEN)
 		max = 9216;
 	else
 		max = 1522;
 
-	/* The XMAC_MIN register only accepts values for TX min which
-	 * have the low 3 bits cleared.
-	 */
-	BUILD_BUG_ON(min & 0x7);
-
 	if (np->flags & NIU_FLAGS_XMAC)
 		niu_init_tx_xmac(np, min, max);
 	else
-- 
1.5.6.rc1.5.gadf6


