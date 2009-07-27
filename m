Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZG0JIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZG0JIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 05:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbZG0JIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 05:08:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:4442 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZG0JIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:08:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=MMyPQ7tsWXePcD/lQ6XxyV7xDGV4xjvvALYPMnqoCWRT5575yGgguErO8XM9ujGLv
	Yk5vmS96G7TS2mCUTwQJw==
Subject: [PATCH] IPVS: logging sizeof(struct ip_vs_conn) on startup
To: netdev@vger.kernel.org
From: Hannes Eder <heder@google.com>
Cc: lvs-users@linuxvirtualserver.org, malcolm@loadbalancer.org,
       linux-kernel@vger.kernel.org
Date: Mon, 27 Jul 2009 11:08:34 +0200
Message-ID: <20090727090741.16509.35291.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No more guessing, how much memory is used by IPVS for a connection.

Signed-off-by: Hannes Eder <heder@google.com>
---
 net/netfilter/ipvs/ip_vs_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_core.c b/net/netfilter/ipvs/ip_vs_core.c
index b021464..5b0997c 100644
--- a/net/netfilter/ipvs/ip_vs_core.c
+++ b/net/netfilter/ipvs/ip_vs_core.c
@@ -1475,7 +1475,8 @@ static int __init ip_vs_init(void)
 		goto cleanup_conn;
 	}
 
-	IP_VS_INFO("ipvs loaded.\n");
+	IP_VS_INFO("ipvs loaded (using %Zd bytes/connection).\n",
+	       sizeof(struct ip_vs_conn));
 	return ret;
 
   cleanup_conn:

