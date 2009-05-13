Return-Path: <linux-kernel-owner+w=401wt.eu-S1762243AbZEMWqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762243AbZEMWqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761335AbZEMWou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:44:50 -0400
Received: from gimli.pxnet.com ([195.227.45.7]:38987 "EHLO mail.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760772AbZEMWoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:44:37 -0400
From: Tilman Schmidt <tilman@imap.cc>
To: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
CC: Hansjoerg Lipp <hjlipp@web.de>
Message-ID: <20090514-patch-04.tilman@imap.cc>
In-Reply-To: <20090514-patch-00.tilman@imap.cc>
References: <20090514-patch-00.tilman@imap.cc>
Subject: [PATCH 4/8] gigaset: skip unnecessary hex formatting
Date: Thu, 14 May 2009 00:44:17 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't generate the hex representation of the payload data if it
isn't actually used afterwards.

Impact: optimization
Signed-off-by: Tilman Schmidt <tilman@imap.cc>
---
 drivers/isdn/gigaset/isocdata.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/gigaset/isocdata.c b/drivers/isdn/gigaset/isocdata.c
index b171e75..09202a5 100644
--- a/drivers/isdn/gigaset/isocdata.c
+++ b/drivers/isdn/gigaset/isocdata.c
@@ -246,6 +246,10 @@ static inline void dump_bytes(enum debuglevel level, const char *tag,
 	unsigned char c;
 	static char dbgline[3 * 32 + 1];
 	int i = 0;
+
+	if (!(gigaset_debuglevel & level))
+		return;
+
 	while (count-- > 0) {
 		if (i > sizeof(dbgline) - 4) {
 			dbgline[i] = '\0';
-- 
1.6.2.1.214.ge986c

