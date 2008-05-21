Return-Path: <linux-kernel-owner+w=401wt.eu-S932508AbYEUC1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbYEUC1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 22:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbYEUC1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 22:27:43 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:40998 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169AbYEUC1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 22:27:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MCowS1zALUVJMen5mV5UvsRKjxbv5DANBLWBl63u1Ncv8fMxvEBllOAvwJmi/F45ajzNw6u99vYic+h8V8oH50cCnnmG0u7MdwDoq38bfHUXWjDER7EBfB7hEybqX0AiY2ZmtJyNOk7fUw0GZkX2SJLEbj/QtiZLcBL1z2ztE2o=
Message-ID: <91b13c310805201927k4fccf8dcwa3fabe61777b2eda@mail.gmail.com>
Date: Wed, 21 May 2008 10:27:41 +0800
From: "rae l" <crquan@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from lib/hexdump.c instead
Cc: harvey.harrison@gmail.com, herbert@gondor.apana.org.au,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080520.154551.54365414.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1211135864-8235-1-git-send-email-crquan@gmail.com>
	 <20080520.153611.204837174.davem@davemloft.net>
	 <1211323212.5915.220.camel@brick>
	 <20080520.154551.54365414.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bc47e710a3ebd8a5989404f711a051b6516d01ed Mon Sep 17 00:00:00 2001
From: Denis Cheng <crquan@gmail.com>
Date: Wed, 21 May 2008 09:43:32 +0800
Subject: [PATCH] net/ipv4/arp.c: Use common hex_asc helpers

Here the local hexbuf is a duplicate of global const char hex_asc from
lib/hexdump.c, except the hex letters' cases:

	const char hexbuf[] = "0123456789ABCDEF";

	const char hex_asc[] = "0123456789abcdef";

and here to print HW addresses, the hex cases are not significant.

Thanks to Harvey Harrison to introduce the hex_asc_hi/hex_asc_lo helpers.

Signed-off-by: Denis Cheng <crquan@gmail.com>
Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/arp.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 418862f..9b539fa 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1288,7 +1288,6 @@ static void arp_format_neigh_entry(struct seq_file *seq,
 				   struct neighbour *n)
 {
 	char hbuffer[HBUFFERLEN];
-	const char hexbuf[] = "0123456789ABCDEF";
 	int k, j;
 	char tbuf[16];
 	struct net_device *dev = n->dev;
@@ -1302,8 +1301,8 @@ static void arp_format_neigh_entry(struct seq_file *seq,
 	else {
 #endif
 	for (k = 0, j = 0; k < HBUFFERLEN - 3 && j < dev->addr_len; j++) {
-		hbuffer[k++] = hexbuf[(n->ha[j] >> 4) & 15];
-		hbuffer[k++] = hexbuf[n->ha[j] & 15];
+		hbuffer[k++] = hex_asc_hi(n->ha[j]);
+		hbuffer[k++] = hex_asc_lo(n->ha[j]);
 		hbuffer[k++] = ':';
 	}
 	hbuffer[--k] = 0;
-- 
1.5.4.3
