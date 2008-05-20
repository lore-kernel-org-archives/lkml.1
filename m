Return-Path: <linux-kernel-owner+w=401wt.eu-S935672AbYETWpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935672AbYETWpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 18:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760865AbYETWmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 18:42:04 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:42250 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935481AbYETWmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 18:42:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m9mwP/7GGNqPLg9Wp3ywXt/NqPRFhCzPbQXB6eNoOKvRFhwS76RO/ex6WYTAGvPgAneHulj5UOIUJ6ohSKw27iROpkgMwNCT12mlOlynpnGjny/k/d7NWGq16czlVd2m6f24D8QBLu/rsm8SOBfupTR8oFXIApX4yYvgSUGkPv4=
Subject: Re: [PATCH] net/ipv4/arp.c: Use the exported hex_asc from
	lib/hexdump.c instead
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: crquan@gmail.com, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080520.153611.204837174.davem@davemloft.net>
References: <1211135864-8235-1-git-send-email-crquan@gmail.com>
	 <20080520.153611.204837174.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 20 May 2008 15:41:59 -0700
Message-Id: <1211323319.5915.223.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] net: use common hex_asc helpers

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Something like this.

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
1.5.5.1.570.g26b5e



