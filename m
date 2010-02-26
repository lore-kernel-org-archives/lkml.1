Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965502Ab0BZRf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:35:59 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:10189
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965460Ab0BZRf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:35:58 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz936eMab9bhzz1202hzzz32i6bh87h43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7M-02-2LG-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       Robert Richter <robert.richter@amd.com>, stable <stable@kernel.org>
Subject: [PATCH 04/15] oprofile/x86: remove node check in AMD IBS initialization
Date: Fri, 26 Feb 2010 18:29:56 +0100
Message-ID: <1267205407-6523-5-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0085 (UTC) FILETIME=[215E13D0:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Standard AMD systems have the same number of nodes as there are
northbridge devices. However, there may kernel configurations
(especially for 32 bit) or system setups exist, where the node number
is different or it can not be detected properly. Thus the check is not
reliable and may fail though IBS setup was fine. For this reason it is
better to remove the check.

Cc: stable <stable@kernel.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 2b9c68d..4eb3071 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -389,16 +389,6 @@ static int init_ibs_nmi(void)
 		return 1;
 	}
 
-#ifdef CONFIG_NUMA
-	/* Sanity check */
-	/* Works only for 64bit with proper numa implementation. */
-	if (nodes != num_possible_nodes()) {
-		printk(KERN_DEBUG "Failed to setup CPU node(s) for IBS, "
-			"found: %d, expected %d",
-			nodes, num_possible_nodes());
-		return 1;
-	}
-#endif
 	return 0;
 }
 
-- 
1.6.6


