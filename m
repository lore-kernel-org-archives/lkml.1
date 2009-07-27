Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZG0NPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZG0NPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753626AbZG0NPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:15:52 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31877 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZG0NPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:15:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:date:message-id:user-agent:mime-version:
	content-type:content-transfer-encoding:to:cc:cc:cc:cc:cc:references:in-reply-to;
	b=iAiLrNnGxtG+0+ph3HhpGtwhw6qUzyiy0fnrdNdq2Za3fpnsbrBMQXPy47rF6y67R
	d8sZjekGXd57SJ4JVW7Fw==
Subject: [PATCH v2] IPVS: logging sizeof(struct ip_vs_conn) on startup
From: Hannes Eder <heder@google.com>
Date: Mon, 27 Jul 2009 15:13:57 +0200
Message-ID: <20090727131357.9561.39720.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netdev@vger.kernel.org
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lvs-users@linuxvirtualserver.org
Cc: malcolm@loadbalancer.org
Cc: linux-kernel@vger.kernel.org
Cc: Simon Horman <horms@verge.net.au>
References: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
	 <4A6D7285.9080909@gmail.com>
	 <b5ddba180907270334m4bc4e968m85c16ea4756c3f5d@mail.gmail.com>
In-Reply-To: <b5ddba180907270334m4bc4e968m85c16ea4756c3f5d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more guessing, how much memory used by IPVS for a connection.

[ The number printed is a lower bound, as ip_vs_conn_cache uses
SLAB_HWCACHE_ALIGN. ]

Signed-off-by: Hannes Eder <heder@google.com>
Signed-off-by: Simon Horman <horms@verge.net.au>

 net/netfilter/ipvs/ip_vs_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index b021464..b6bb4a0 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1475,7 +1475,8 @@ static int __init ip_vs_init(void)
 		goto cleanup_conn;
 	}
 
-	IP_VS_INFO("ipvs loaded.\n");
+	IP_VS_INFO("ipvs loaded (using at least %Zd bytes/connection).\n",
+	       sizeof(struct ip_vs_conn));
 	return ret;
 
   cleanup_conn:

