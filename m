Return-Path: <linux-kernel-owner+w=401wt.eu-S1756526AbYHDD2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526AbYHDD2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 23:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYHDD2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 23:28:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55763 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbYHDD2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 23:28:08 -0400
Message-ID: <489676EE.8000505@cn.fujitsu.com>
Date: Mon, 04 Aug 2008 11:26:38 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove nesting CONFIG_HOTPLUG_CPU
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prefill_possible_map() is defined inside CONFIG_HOTPLUG_CPU,
so the nesting CONFIG_HOTPLUG_CPU is just redundant.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 arch/x86/kernel/smpboot.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 3325127..d5e19c3 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1271,16 +1271,13 @@ __init void prefill_possible_map(void)
 	if (!num_processors)
 		num_processors = 1;
 
-#ifdef CONFIG_HOTPLUG_CPU
 	if (additional_cpus == -1) {
 		if (disabled_cpus > 0)
 			additional_cpus = disabled_cpus;
 		else
 			additional_cpus = 0;
 	}
-#else
-	additional_cpus = 0;
-#endif
+
 	possible = num_processors + additional_cpus;
 	if (possible > NR_CPUS)
 		possible = NR_CPUS;
-- 
1.5.4.rc3
