Return-Path: <linux-kernel-owner+w=401wt.eu-S1755871AbYCIX5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871AbYCIX5N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYCIX4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:56:44 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:4372 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYCIX4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:56:43 -0400
Subject: [PATCH] include/linux/igmp.h - remove duplicate include
From: Joe Perches <joe@perches.com>
To: netdev <netdev@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 09 Mar 2008 16:55:40 -0700
Message-Id: <1205106940.656.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.2mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed duplicate #include <linux/skbuff.h>	
Combined #ifdef __KERNEL__ blocks

Signed-off-by: Joe Perches <joe@perches.com>

 include/linux/igmp.h |   38 +++++++++++++++++---------------------
 1 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/include/linux/igmp.h b/include/linux/igmp.h
index f510e7e..f5a1a0d 100644
--- a/include/linux/igmp.h
+++ b/include/linux/igmp.h
@@ -80,27 +80,6 @@ struct igmpv3_query {
 	__be32 srcs[0];
 };
 
-#ifdef __KERNEL__
-#include <linux/skbuff.h>
-
-static inline struct igmphdr *igmp_hdr(const struct sk_buff *skb)
-{
-	return (struct igmphdr *)skb_transport_header(skb);
-}
-
-static inline struct igmpv3_report *
-			igmpv3_report_hdr(const struct sk_buff *skb)
-{
-	return (struct igmpv3_report *)skb_transport_header(skb);
-}
-
-static inline struct igmpv3_query *
-			igmpv3_query_hdr(const struct sk_buff *skb)
-{
-	return (struct igmpv3_query *)skb_transport_header(skb);
-}
-#endif
-
 #define IGMP_HOST_MEMBERSHIP_QUERY	0x11	/* From RFC1112 */
 #define IGMP_HOST_MEMBERSHIP_REPORT	0x12	/* Ditto */
 #define IGMP_DVMRP			0x13	/* DVMRP routing */
@@ -151,6 +130,23 @@ static inline struct igmpv3_query *
 #include <linux/timer.h>
 #include <linux/in.h>
 
+static inline struct igmphdr *igmp_hdr(const struct sk_buff *skb)
+{
+	return (struct igmphdr *)skb_transport_header(skb);
+}
+
+static inline struct igmpv3_report *
+			igmpv3_report_hdr(const struct sk_buff *skb)
+{
+	return (struct igmpv3_report *)skb_transport_header(skb);
+}
+
+static inline struct igmpv3_query *
+			igmpv3_query_hdr(const struct sk_buff *skb)
+{
+	return (struct igmpv3_query *)skb_transport_header(skb);
+}
+
 extern int sysctl_igmp_max_memberships;
 extern int sysctl_igmp_max_msf;
 


