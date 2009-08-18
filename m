Return-Path: <linux-kernel-owner+w=401wt.eu-S1755886AbZHRDYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbZHRDYd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 23:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZHRDYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 23:24:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:60458 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZHRDYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 23:24:23 -0400
From: Chunbo Luo <chunbo.luo@windriver.com>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Cc: chunbo.luo@windriver.com
Subject: [PATCH 2/2] sctp: fix heartbeat process of path failure
Date: Tue, 18 Aug 2009 11:24:16 +0800
Message-Id: <1250565856-18198-2-git-send-email-chunbo.luo@windriver.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1250565856-18198-1-git-send-email-chunbo.luo@windriver.com>
References: <1250565856-18198-1-git-send-email-chunbo.luo@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RFC4960 Section 8.2 defined that the transport should enter INACTIVE
state only when the value in the error counter exceeds the protocol 
parameter 'Path.Max.Retrans' of that destination address. This means 
that the transport should enter INACTIVE state after pathmaxrxt+1
heartbeats are not acknowledged.


Signed-off-by: Chunbo Luo <chunbo.luo@windriver.com>
---
 net/sctp/sm_sideeffect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sctp/sm_sideeffect.c b/net/sctp/sm_sideeffect.c
index 86426aa..0e2e269 100644
--- a/net/sctp/sm_sideeffect.c
+++ b/net/sctp/sm_sideeffect.c
@@ -447,7 +447,7 @@ static void sctp_do_8_2_transport_strike(struct sctp_association *asoc,
 		asoc->overall_error_count++;
 
 	if (transport->state != SCTP_INACTIVE &&
-	    (transport->error_count++ >= transport->pathmaxrxt)) {
+	    (transport->error_count++ > transport->pathmaxrxt)) {
 		SCTP_DEBUG_PRINTK_IPADDR("transport_strike:association %p",
 					 " transport IP: port:%d failed.\n",
 					 asoc,
-- 
1.6.4

