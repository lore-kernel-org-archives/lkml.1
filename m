Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZDWAgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZDWAgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZDWAg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:36:27 -0400
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:44273 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750755AbZDWAg0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:36:26 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] net/ipv6/tcp_ipv6.c: fix sparse warnings
Date: Wed, 22 Apr 2009 20:35:39 -0400
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090165F12C@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] net/ipv6/tcp_ipv6.c: fix sparse warnings
Thread-Index: AcnDq2zdgJbEjyRAS+WZAE7R3u7yCQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 23 Apr 2009 00:36:24.0889 (UTC) FILETIME=[8836DA90:01C9C3AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warnings in net/ipv6/tcp_ipv6.c.

  warning: symbol 'tcp6_gro_receive' was not declared. Should it be static?
  warning: symbol 'tcp6_gro_complete' was not declared. Should it be static?

Both symbols are exported but not referenced anywhere outside of
this source file. Remove the exports and make the functions static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 4b5aa18..d391555 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -941,7 +941,7 @@ static int tcp_v6_gso_send_check(struct sk_buff *skb)
 	return 0;
 }
 
-struct sk_buff **tcp6_gro_receive(struct sk_buff **head, struct sk_buff *skb)
+static struct sk_buff **tcp6_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 
@@ -961,9 +961,8 @@ struct sk_buff **tcp6_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 
 	return tcp_gro_receive(head, skb);
 }
-EXPORT_SYMBOL(tcp6_gro_receive);
 
-int tcp6_gro_complete(struct sk_buff *skb)
+static int tcp6_gro_complete(struct sk_buff *skb)
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	struct tcphdr *th = tcp_hdr(skb);
@@ -974,7 +973,6 @@ int tcp6_gro_complete(struct sk_buff *skb)
 
 	return tcp_gro_complete(skb);
 }
-EXPORT_SYMBOL(tcp6_gro_complete);
 
 static void tcp_v6_send_response(struct sk_buff *skb, u32 seq, u32 ack, u32 win,
 				 u32 ts, struct tcp_md5sig_key *key, int rst) 
