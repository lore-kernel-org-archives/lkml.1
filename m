Return-Path: <linux-kernel-owner+w=401wt.eu-S1753984AbZK3KDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984AbZK3KDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 05:03:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbZK3KDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 05:03:47 -0500
Received: from smtp.iptel.org ([213.192.59.67]:37591 "EHLO mail.iptel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZK3KDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 05:03:47 -0500
Date: Mon, 30 Nov 2009 10:52:50 +0100
From: Andrei Pelinescu-Onciul <andrei@iptel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "David S. Miller" <davem@davemloft.net>,
       Vlad Yasevich <vladislav.yasevich@hp.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org
Subject: [PATCH] sctp: fix sctp_setsockopt_autoclose compile warning
Message-ID: <20091130095250.GZ10897@shell.iptel.org>
References: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au> <20091130094929.GY10897@shell.iptel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130094929.GY10897@shell.iptel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following warning, when building on 64 bits:

net/sctp/socket.c:2091: warning: large integer implicitly
                        truncated to unsigned type

Signed-off-by: Andrei Pelinescu-Onciul <andrei@iptel.org>
---
 net/sctp/socket.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 71513b3..8961863 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -2088,7 +2088,7 @@ static int sctp_setsockopt_autoclose(struct sock *sk, char __user *optval,
 		return -EFAULT;
 	/* make sure it won't exceed MAX_SCHEDULE_TIMEOUT */
 	if (sp->autoclose > (MAX_SCHEDULE_TIMEOUT / HZ) )
-		sp->autoclose = MAX_SCHEDULE_TIMEOUT / HZ ;
+		sp->autoclose = (__u32)(MAX_SCHEDULE_TIMEOUT / HZ) ;
 
 	return 0;
 }
-- 
1.6.5.3

