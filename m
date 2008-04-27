Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbYD0Fke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbYD0Fke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 01:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYD0FkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 01:40:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYD0FkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 01:40:22 -0400
Date: Sun, 27 Apr 2008 06:40:21 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] tipc endianness annotations
Message-ID: <20080427054021.GS5882@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 net/tipc/msg.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 6ad070d..ad487e8 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -70,10 +70,9 @@ static inline void msg_set_bits(struct tipc_msg *m, u32 w,
 				u32 pos, u32 mask, u32 val)
 {
 	val = (val & mask) << pos;
-	val = htonl(val);
-	mask = htonl(mask << pos);
-	m->hdr[w] &= ~mask;
-	m->hdr[w] |= val;
+	mask = mask << pos;
+	m->hdr[w] &= ~htonl(mask);
+	m->hdr[w] |= htonl(val);
 }
 
 /*
-- 
1.5.3.GIT

