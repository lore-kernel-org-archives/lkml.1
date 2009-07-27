Return-Path: <linux-kernel-owner+w=401wt.eu-S1752841AbZG0Pba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbZG0Pba (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 11:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZG0Pb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 11:31:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:52140 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbZG0PbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 11:31:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tmKiJboztceoFkGktpOdpjAKS/xX0ysB/ZpbC5ubo4A4cuSm/7WLh9wu4IG802Cjp
	rgxk9WIsQ8DYNj2d0KbhA==
Subject: [RFC][PATCH 1/5] IPVS: prefix EnterFunction and LeaveFunction msg with
	"IPVS:"
To: lvs-devel@vger.kernel.org
From: Hannes Eder <heder@google.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 27 Jul 2009 15:46:16 +0200
Message-ID: <20090727134616.12897.7639.stgit@jazzy.zrh.corp.google.com>
In-Reply-To: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
References: <20090727134457.12897.272.stgit@jazzy.zrh.corp.google.com>
User-Agent: StGit/0.14.3.366.gf979
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Eder <hannes@hanneseder.net>

Now all printk messages from IPVS are prefixed with "IPVS:".

Signed-off-by: Hannes Eder <heder@google.com>

 include/net/ip_vs.h |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index e01cc2d..e03524e 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -161,18 +161,18 @@ static inline const char *ip_vs_dbg_addr(int af, char *buf, size_t buf_len,
     } while (0)
 
 #ifdef CONFIG_IP_VS_DEBUG
-#define EnterFunction(level)						\
-    do {								\
-	    if (level <= ip_vs_get_debug_level())			\
-		    printk(KERN_DEBUG "Enter: %s, %s line %i\n",	\
-			   __func__, __FILE__, __LINE__);		\
-    } while (0)
-#define LeaveFunction(level)                                            \
-    do {                                                                \
-	    if (level <= ip_vs_get_debug_level())                       \
-			printk(KERN_DEBUG "Leave: %s, %s line %i\n",    \
-			       __func__, __FILE__, __LINE__);       \
-    } while (0)
+#define EnterFunction(level)						       \
+	do {								       \
+		if (level <= ip_vs_get_debug_level())			       \
+			printk(KERN_DEBUG "IPVS: Enter: %s, %s line %i\n",     \
+				__func__, __FILE__, __LINE__);		       \
+	} while (0)
+#define LeaveFunction(level)						       \
+	do {								       \
+		if (level <= ip_vs_get_debug_level())			       \
+			printk(KERN_DEBUG "IPVS: Leave: %s, %s line %i\n",     \
+				__func__, __FILE__, __LINE__);		       \
+	} while (0)
 #else
 #define EnterFunction(level)   do {} while (0)
 #define LeaveFunction(level)   do {} while (0)

