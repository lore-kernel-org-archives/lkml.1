Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbYEJMwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbYEJMwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 08:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754918AbYEJMwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 08:52:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:59811 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYEJMwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 08:52:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, davem@davemloft.net
Subject: [patch] linux/atm_tcp.h linux/atm.h: cleanup for userspace
Date: Sat, 10 May 2008 08:52:04 -0400
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805100852.04971.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The atm_tcp.h uses types from linux/atm.h, but does not include it.  It
should also use the standard __u## types from linux/types.h rather than the
uint##_t types since the former can be found with the kernel already.

Same goes for linux/atm.h.  The linux/socket.h include there also gets
dropped as atm.h does not actually use anything from socket.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
diff --git a/include/linux/atm.h b/include/linux/atm.h
index 6013668..c791ddd 100644
--- a/include/linux/atm.h
+++ b/include/linux/atm.h
@@ -16,14 +16,11 @@
  * documentation. Do not change them.
  */
 
-#ifdef __KERNEL__
-#include <linux/socket.h>
-#include <linux/types.h>
-#endif
 #include <linux/compiler.h>
 #include <linux/atmapi.h>
 #include <linux/atmsap.h>
 #include <linux/atmioc.h>
+#include <linux/types.h>
 
 
 /* general ATM constants */
@@ -212,7 +209,7 @@ struct sockaddr_atmsvc {
         char		pub[ATM_E164_LEN+1]; /* public address (E.164) */
     					/* unused addresses must be bzero'ed */
 	char		lij_type;	/* role in LIJ call; one of ATM_LIJ* */
-	uint32_t	lij_id;		/* LIJ call identifier */
+	__u32	lij_id;		/* LIJ call identifier */
     } sas_addr __ATM_API_ALIGN;		/* SVC address */
 };
 
diff --git a/include/linux/atm_tcp.h b/include/linux/atm_tcp.h
index 18787f9..375638f 100644
--- a/include/linux/atm_tcp.h
+++ b/include/linux/atm_tcp.h
@@ -8,11 +8,9 @@
 #define LINUX_ATM_TCP_H
 
 #include <linux/atmapi.h>
-
-#ifdef __KERNEL__
-#include <linux/types.h>
-#endif
+#include <linux/atm.h>
 #include <linux/atmioc.h>
+#include <linux/types.h>
 
 
 /*
@@ -20,9 +18,9 @@
  */
 
 struct atmtcp_hdr {
-	uint16_t	vpi;
-	uint16_t	vci;
-	uint32_t	length;		/* ... of data part */
+	__u16	vpi;
+	__u16	vci;
+	__u32	length;		/* ... of data part */
 };
 
 /*
