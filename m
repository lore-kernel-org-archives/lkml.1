Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZG1PJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZG1PJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbZG1PGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:06:45 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12074 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678AbZG1PGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:06:42 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNHZAT-02-6PL-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 20/20] x86, mce: do not compile mcelog message on AMD
Date: Tue, 28 Jul 2009 17:06:20 +0200
Message-ID: <1248793580-29899-21-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:31.0175 (UTC) FILETIME=[FD3DE970:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that decoding is done in-kernel, suppress mcelog message part.

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 69e7d8e..f7a2b42 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -222,7 +222,10 @@ static void print_mce_head(void)
 static void print_mce_tail(void)
 {
 	printk(KERN_EMERG "This is not a software problem!\n"
-	       "Run through mcelog --ascii to decode and contact your hardware vendor\n");
+#if (!defined(CONFIG_EDAC) || !defined(CONFIG_CPU_SUP_AMD))
+	       "Run through mcelog --ascii to decode and contact your hardware vendor\n"
+#endif
+	       );
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
-- 
1.6.3.3


