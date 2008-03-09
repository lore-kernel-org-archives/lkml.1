Return-Path: <linux-kernel-owner+w=401wt.eu-S1756168AbYCIX5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168AbYCIX5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYCIX4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:56:51 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4375 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbYCIX4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:56:48 -0400
Subject: [PATCH] include/linux/udp.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:45 -0700
Message-Id: <1205106945.656.104.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate #include <linux/types.h>
Combine #ifdef __KERNEL__ blocks

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/udp.h |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/include/linux/udp.h b/include/linux/udp.h
index 8ec703f..d3730a8 100644
--- a/include/linux/udp.h
+++ b/include/linux/udp.h
@@ -26,15 +26,6 @@ struct udphdr {
 	__sum16	check;
 };
 
-#ifdef __KERNEL__
-#include <linux/skbuff.h>
-
-static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
-{
-	return (struct udphdr *)skb_transport_header(skb);
-}
-#endif
-
 /* UDP socket options */
 #define UDP_CORK	1	/* Never send partially complete segments */
 #define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
@@ -45,9 +36,14 @@ static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
 #define UDP_ENCAP_L2TPINUDP	3 /* rfc2661 */
 
 #ifdef __KERNEL__
-#include <linux/types.h>
-
 #include <net/inet_sock.h>
+#include <linux/skbuff.h>
+
+static inline struct udphdr *udp_hdr(const struct sk_buff *skb)
+{
+	return (struct udphdr *)skb_transport_header(skb);
+}
+
 #define UDP_HTABLE_SIZE		128
 
 struct udp_sock {


