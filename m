Return-Path: <linux-kernel-owner+w=401wt.eu-S1757652Ab0ANU1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757652Ab0ANU1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 15:27:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757627Ab0ANU1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 15:27:43 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:60406 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757611Ab0ANU1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 15:27:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=luwOC2CZTHRS36KW90Mropu46RUEbqdtngUaUWC6E6qS5J1ZI3jdBmx/hesC/x2RL2
         1faWNV0LZng9CozSTKG4vSI0sExiqsXb1/j8eZNEuQq2mpdCDuJwFIesr9rLXc68dbAc
         uvVig83W/XX7ZfMVPr0yJi0UBi9zOJPtIQ69A=
Message-ID: <4B4F7F4B.8000302@gmail.com>
Date: Thu, 14 Jan 2010 21:32:11 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] [NET]: da.s_net not copied but assigned to itself in aarp_rcv()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da.s_net was not copied but assigned to itself.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/net/appletalk/aarp.c b/net/appletalk/aarp.c
index 9d4adfd..f2b3b56 100644
--- a/net/appletalk/aarp.c
+++ b/net/appletalk/aarp.c
@@ -819,7 +819,7 @@ static int aarp_rcv(struct sk_buff *skb, struct net_device *dev,
 				ma = &ifa->address;
 			else { /* We need to make a copy of the entry. */
 				da.s_node = sa.s_node;
-				da.s_net = da.s_net;
+				da.s_net = sa.s_net;
 				ma = &da;
 			}
 
