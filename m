Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbZIOPTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbZIOPTH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 11:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZIOPTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 11:19:05 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:58200
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754686AbZIOPTE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 11:19:04 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh203h43j63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KQ0QH3-02-9P0-02
X-M-MSG: 
Date: Tue, 15 Sep 2009 17:17:27 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86, mce: Fix compile warning in case of CONFIG_SMP=n
Message-ID: <20090915151727.GB21670@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Sep 2009 15:17:28.0204 (UTC) FILETIME=[A31A54C0:01CA3617]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fix following compile warning:

  arch/x86/kernel/cpu/mcheck/mce_amd.c: In function ‘threshold_create_bank’:
  arch/x86/kernel/cpu/mcheck/mce_amd.c:492: warning: unused variable ‘c’

which shows up when kernel is compiled with CONFIG_SMP=n.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 1fecba4..9e96043 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -489,8 +489,9 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	int i, err = 0;
 	struct threshold_bank *b = NULL;
 	char name[32];
+#ifdef CONFIG_SMP
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-
+#endif
 
 	sprintf(name, "threshold_bank%i", bank);
 
-- 
1.6.2.5



