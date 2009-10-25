Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbZJYT34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbZJYT34 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:29:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZJYT3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:29:54 -0400
Received: from mail.pxnet.com ([195.227.45.7]:43560 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbZJYT3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:29:52 -0400
From: Tilman Schmidt <tilman@imap.cc>
Subject: [PATCH 2/9] gigaset: fix format string typo in CAPI dial command
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       i4ldeveloper@listserv.isdn4linux.de
Message-ID: <20091023-patch-gigaset-02.tilman@imap.cc>
In-Reply-To: <20091023-patch-gigaset-00.tilman@imap.cc>
References: <20091023-patch-gigaset-00.tilman@imap.cc>
Date: Sun, 25 Oct 2009 20:29:47 +0100 (CET)
X-Spam-Score: -2.166 () AWL,BAYES_00,RDNS_NONE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A missing dot lead to garbage characters being included in the
dial command generated from a CAPI CONNECT_REQ message, which
interestingly enough worked anyway, illustrating the resilience
of the device.

Impact: bugfix
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/capi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index ac0a2da..d1afac2 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -1254,7 +1254,7 @@ static void do_connect_req(struct gigaset_capi_ctr *iif,
 	commands[AT_DIAL] = kmalloc(l+3, GFP_KERNEL);
 	if (!commands[AT_DIAL])
 		goto oom;
-	snprintf(commands[AT_DIAL], l+3, "D%*s\r", l, pp);
+	snprintf(commands[AT_DIAL], l+3, "D%.*s\r", l, pp);
 
 	/* encode parameter: Calling party number */
 	pp = cmsg->CallingPartyNumber;
-- 
1.6.2.1.214.ge986c

