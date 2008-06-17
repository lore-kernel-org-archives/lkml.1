Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbYFQHxi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbYFQHxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 03:53:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYFQHxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 03:53:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755273AbYFQHxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 03:53:04 -0400
Date: Tue, 17 Jun 2008 00:53:04 -0700 (PDT)
Message-Id: <20080617.005304.207929650.davem@davemloft.net>
To: linville@tuxdriver.com
CC: mokuno@sm.sony.co.jp, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/12]: wext: Remove inline from get_priv_size() and
 adjust_priv_size().
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wext: Remove inline from get_priv_size() and adjust_priv_size().

The compiler inlines when appropriate.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/wireless/wext.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/wireless/wext.c b/net/wireless/wext.c
index 947188a..e83d74a 100644
--- a/net/wireless/wext.c
+++ b/net/wireless/wext.c
@@ -500,7 +500,7 @@ static int call_commit_handler(struct net_device *dev)
 /*
  * Calculate size of private arguments
  */
-static inline int get_priv_size(__u16	args)
+static int get_priv_size(__u16 args)
 {
 	int	num = args & IW_PRIV_SIZE_MASK;
 	int	type = (args & IW_PRIV_TYPE_MASK) >> 12;
@@ -512,8 +512,7 @@ static inline int get_priv_size(__u16	args)
 /*
  * Re-calculate the size of private arguments
  */
-static inline int adjust_priv_size(__u16		args,
-				   union iwreq_data *	wrqu)
+static int adjust_priv_size(__u16 args, union iwreq_data *wrqu)
 {
 	int	num = wrqu->data.length;
 	int	max = args & IW_PRIV_SIZE_MASK;
-- 
1.5.5.1.308.g1fbb5

