Return-Path: <linux-kernel-owner+w=401wt.eu-S1759525AbYFCUlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759525AbYFCUlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 16:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbYFCUhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 16:37:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47084
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752941AbYFCUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 16:36:53 -0400
Date: Tue, 03 Jun 2008 13:28:10 -0700 (PDT)
Message-Id: <20080603.132810.05908596.davem@davemloft.net>
To: linux-wireless@vger.kernel.org
CC: linville@tuxdriver.com, mokuno@sm.sony.co.jp, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/12]: wext: Make adjust_priv_size() take a "struct
 iw_point *".
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/wireless/wext.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index e83d74a..cd2cf9f 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -512,9 +512,9 @@ static int get_priv_size(__u16 args)
 /*
  * Re-calculate the size of private arguments
  */
-static int adjust_priv_size(__u16 args, union iwreq_data *wrqu)
+static int adjust_priv_size(__u16 args, struct iw_point *iwp)
 {
-	int	num = wrqu->data.length;
+	int	num = iwp->length;
 	int	max = args & IW_PRIV_SIZE_MASK;
 	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
 
@@ -976,7 +976,7 @@ static int ioctl_private_call(struct net_device *dev, struct ifreq *ifr,
 			 * avoid leaking kernel bits outside. */
 			if (!(descr->get_args & IW_PRIV_SIZE_FIXED)) {
 				extra_size = adjust_priv_size(descr->get_args,
-							      &(iwr->u));
+							      &(iwr->u.data));
 			}
 
 			err = copy_to_user(iwr->u.data.pointer, extra,
-- 
1.5.5.1.308.g1fbb5

