Return-Path: <linux-kernel-owner+w=401wt.eu-S965351AbYEBTGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965351AbYEBTGS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 15:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965142AbYEBTCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 15:02:04 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:48598 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935868AbYEBTCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 15:02:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=G5SSqSG4PwA4WODlmft86kY/AcJrbJc7IDJhHvWRYkAIlzOBDpMLX9prODH1AGiszL3FzGJ9Bs3FveKIGXJqjTykdoP8C9bAsRbtBMNkTe79YI7nDuHI2mCfLj4jBRy839IHzEzOPpHzosGzokzr5zUUcSqLR01acbxO30lmx9A=
Subject: [PATCH 12/12] net: use the common ascii hex helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 02 May 2008 12:01:56 -0700
Message-Id: <1209754916.26173.39.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/skfp/smt.c             |   13 ++++++-------
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    5 ++---
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/skfp/smt.c b/drivers/net/skfp/smt.c
index ffbfb1b..805383b 100644
--- a/drivers/net/skfp/smt.c
+++ b/drivers/net/skfp/smt.c
@@ -19,6 +19,7 @@
 #include "h/smc.h"
 #include "h/smt_p.h"
 #include <linux/bitrev.h>
+#include <linux/kernel.h>
 
 #define KERNEL
 #include "h/smtstate.h"
@@ -1730,20 +1731,18 @@ void fddi_send_antc(struct s_smc *smc, struct fddi_addr *dest)
 #endif
 
 #ifdef	DEBUG
-#define hextoasc(x)	"0123456789abcdef"[x]
-
 char *addr_to_string(struct fddi_addr *addr)
 {
 	int	i ;
 	static char	string[6*3] = "****" ;
 
 	for (i = 0 ; i < 6 ; i++) {
-		string[i*3] = hextoasc((addr->a[i]>>4)&0xf) ;
-		string[i*3+1] = hextoasc((addr->a[i])&0xf) ;
-		string[i*3+2] = ':' ;
+		string[i * 3] = hex_asc_hi(addr->a[i]);
+		string[i * 3 + 1] = hex_asc_lo(addr->a[i]);
+		string[i * 3 + 2] = ':';
 	}
-	string[5*3+2] = 0 ;
-	return(string) ;
+	string[5 * 3 + 2] = 0;
+	return(string);
 }
 #endif
 
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 22d8e7c..30b11a7 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -475,11 +475,10 @@ static void arp_print(struct arp_payload *payload)
 #define HBUFFERLEN 30
 	char hbuffer[HBUFFERLEN];
 	int j,k;
-	const char hexbuf[]= "0123456789abcdef";
 
 	for (k=0, j=0; k < HBUFFERLEN-3 && j < ETH_ALEN; j++) {
-		hbuffer[k++]=hexbuf[(payload->src_hw[j]>>4)&15];
-		hbuffer[k++]=hexbuf[payload->src_hw[j]&15];
+		hbuffer[k++] = hex_asc_hi(payload->src_hw[j]);
+		hbuffer[k++] = hex_asc_lo(payload->src_hw[j]);
 		hbuffer[k++]=':';
 	}
 	hbuffer[--k]='\0';
-- 
1.5.5.1.350.gbbbf

