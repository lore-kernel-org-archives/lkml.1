Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYJ1EG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYJ1EG4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbYJ1EGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:06:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:60758 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbYJ1EGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:06:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Mp7OOrOCnSU+eYRQt0pQkw1lBIQO3/6zvpKHhzxy6lh7pL/OK+ouDmeL8EZhdHzOG8
         hN3WmI7ggx7+2UpHoG1wGkoYW1IBReZe1KcRLfF5kNK2nMAhZqrps6fapXxyBH1Mpl/+
         9r3JF16JJRUOYXVcEaTA6T7UTpDTb5CW6GH1k=
Subject: [RFC PATCH 2/5] iscsi: bugfix for displaying IPv6 address
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: Johannes Berg <johannes@sipsolutions.net>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 27 Oct 2008 21:05:17 -0700
Message-Id: <1225166717.5526.17.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Notice that ip is a u8 *, so currently every other byte is
being truncated here.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/firmware/iscsi_ibft.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/iscsi_ibft.c b/drivers/firmware/iscsi_ibft.c
index 4353414..0a64720 100644
--- a/drivers/firmware/iscsi_ibft.c
+++ b/drivers/firmware/iscsi_ibft.c
@@ -290,9 +290,7 @@ static ssize_t sprintf_ipaddr(char *buf, u8 *ip)
 		/*
 		 * IPv6
 		 */
-		str += sprintf(str, NIP6_FMT, ntohs(ip[0]), ntohs(ip[1]),
-			       ntohs(ip[2]), ntohs(ip[3]), ntohs(ip[4]),
-			       ntohs(ip[5]), ntohs(ip[6]), ntohs(ip[7]));
+		str += sprintf(str, "%p6", ip);
 	}
 	str += sprintf(str, "\n");
 	return str - buf;
-- 
1.6.0.3.729.g6ea410


