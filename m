Return-Path: <linux-kernel-owner+w=401wt.eu-S1752964AbYKAKSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbYKAKSn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 06:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751395AbYKAKSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 06:18:36 -0400
Received: from smtp.zeuux.org ([210.51.160.52]:58241 "EHLO z.billxu.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYKAKSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 06:18:36 -0400
Date: Sat, 1 Nov 2008 18:18:35 +0800
From: Jianjun Kong <jianjun@zeuux.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: netdev <netdev@vger.kernel.org>,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: [PATCH/2] nets: fix problem of return value
Message-ID: <20081101101835.GG6556@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fix problem of return value

net/unix/af_unix.c: unix_net_init()
when error appears, it should return 'error', not always return 0.

Signed-off-by: Jianjun Kong <jianjun@zeuux.org>
---
 net/unix/af_unix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 0b80634..7d2e4f8 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2212,7 +2212,7 @@ static int unix_net_init(struct net *net)
 #endif
 	error = 0;
 out:
-	return 0;
+	return error;
 }
 
 static void unix_net_exit(struct net *net)
-- 
1.5.6.3

