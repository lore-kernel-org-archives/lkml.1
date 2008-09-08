Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYIHRrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYIHRrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYIHRrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:47:20 -0400
Received: from ns.suse.de ([195.135.220.2]:37771 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbYIHRrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:47:19 -0400
Date: Mon, 8 Sep 2008 10:46:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.26.5
Message-ID: <20080908174638.GB22061@suse.de>
References: <20080908174604.GA22061@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080908174604.GA22061@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/Makefile b/Makefile
index 63c96c6..56fb747 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 26
-EXTRAVERSION = .4
+EXTRAVERSION = .5
 NAME = Rotary Wombat
 
 # *DOCUMENTATION*
diff --git a/include/linux/mroute.h b/include/linux/mroute.h
index 35a8277..5e30ac3 100644
--- a/include/linux/mroute.h
+++ b/include/linux/mroute.h
@@ -2,7 +2,10 @@
 #define __LINUX_MROUTE_H
 
 #include <linux/sockios.h>
+#include <linux/types.h>
+#ifdef __KERNEL__
 #include <linux/in.h>
+#endif
 
 /*
  *	Based on the MROUTING 3.5 defines primarily to keep
@@ -126,6 +129,7 @@ struct igmpmsg
  */
 
 #ifdef __KERNEL__
+#include <linux/pim.h>
 #include <net/sock.h>
 
 #ifdef CONFIG_IP_MROUTE
@@ -210,27 +214,6 @@ struct mfc_cache
 #define IGMPMSG_WHOLEPKT	3		/* For PIM Register processing */
 
 #ifdef __KERNEL__
-
-#define PIM_V1_VERSION		__constant_htonl(0x10000000)
-#define PIM_V1_REGISTER		1
-
-#define PIM_VERSION		2
-#define PIM_REGISTER		1
-
-#define PIM_NULL_REGISTER	__constant_htonl(0x40000000)
-
-/* PIMv2 register message header layout (ietf-draft-idmr-pimvsm-v2-00.ps */
-
-struct pimreghdr
-{
-	__u8	type;
-	__u8	reserved;
-	__be16	csum;
-	__be32	flags;
-};
-
-extern int pim_rcv_v1(struct sk_buff *);
-
 struct rtmsg;
 extern int ipmr_get_route(struct sk_buff *skb, struct rtmsg *rtm, int nowait);
 #endif
diff --git a/include/linux/mroute6.h b/include/linux/mroute6.h
index e798959..90010dd 100644
--- a/include/linux/mroute6.h
+++ b/include/linux/mroute6.h
@@ -115,6 +115,7 @@ struct sioc_mif_req6
 
 #ifdef __KERNEL__
 
+#include <linux/pim.h>
 #include <linux/skbuff.h>	/* for struct sk_buff_head */
 
 #ifdef CONFIG_IPV6_MROUTE
diff --git a/include/linux/pim.h b/include/linux/pim.h
new file mode 100644
index 0000000..1ba0661
--- /dev/null
+++ b/include/linux/pim.h
@@ -0,0 +1,27 @@
+#ifndef __LINUX_PIM_H
+#define __LINUX_PIM_H
+
+#include <asm/byteorder.h>
+
+/* Message types - V1 */
+#define PIM_V1_VERSION		__constant_htonl(0x10000000)
+#define PIM_V1_REGISTER		1
+
+/* Message types - V2 */
+#define PIM_VERSION		2
+#define PIM_REGISTER		1
+
+#define PIM_NULL_REGISTER	__constant_htonl(0x40000000)
+
+/* PIMv2 register message header layout (ietf-draft-idmr-pimvsm-v2-00.ps */
+struct pimreghdr
+{
+	__u8	type;
+	__u8	reserved;
+	__be16	csum;
+	__be32	flags;
+};
+
+struct sk_buff;
+extern int pim_rcv_v1(struct sk_buff *);
+#endif
