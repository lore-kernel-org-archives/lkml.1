Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbYI0VDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbYI0VDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 17:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYI0VDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 17:03:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYI0VDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 17:03:08 -0400
Date: Sat, 27 Sep 2008 23:02:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20080927210252.GA23006@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Katz (1):
      x86: disable apm on the olpc


 arch/x86/kernel/apm_32.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 9ee24e6..732d1f4 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -234,6 +234,7 @@
 #include <asm/uaccess.h>
 #include <asm/desc.h>
 #include <asm/i8253.h>
+#include <asm/olpc.h>
 #include <asm/paravirt.h>
 #include <asm/reboot.h>
 
@@ -2217,7 +2218,7 @@ static int __init apm_init(void)
 
 	dmi_check_system(apm_dmi_table);
 
-	if (apm_info.bios.version == 0 || paravirt_enabled()) {
+	if (apm_info.bios.version == 0 || paravirt_enabled() || machine_is_olpc()) {
 		printk(KERN_INFO "apm: BIOS not found.\n");
 		return -ENODEV;
 	}
