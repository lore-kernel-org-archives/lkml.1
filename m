Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbYGOVCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbYGOVCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754306AbYGOVC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:02:26 -0400
Received: from www.tglx.de ([62.245.132.106]:44552 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752155AbYGOVCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:02:25 -0400
Date: Tue, 15 Jul 2008 23:01:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] x86 updates
Message-ID: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86/urgent git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/urgent

Thanks,

	tglx

------------------>

Thomas Gleixner (1):
      x86: fix TSC build error on 32bit


 arch/x86/kernel/tsc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 3c36f92..7603c05 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -358,6 +358,7 @@ static cycle_t read_tsc(void)
 		ret : clocksource_tsc.cycle_last;
 }
 
+#ifdef CONFIG_X86_64
 static cycle_t __vsyscall_fn vread_tsc(void)
 {
 	cycle_t ret = (cycle_t)vget_cycles();
@@ -365,6 +366,7 @@ static cycle_t __vsyscall_fn vread_tsc(void)
 	return ret >= __vsyscall_gtod_data.clock.cycle_last ?
 		ret : __vsyscall_gtod_data.clock.cycle_last;
 }
+#endif
 
 static struct clocksource clocksource_tsc = {
 	.name                   = "tsc",
