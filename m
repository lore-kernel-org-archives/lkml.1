Return-Path: <linux-kernel-owner+w=401wt.eu-S1754152AbYJASGC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152AbYJASGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 14:06:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYJASFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 14:05:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363AbYJASFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 14:05:50 -0400
Date: Wed, 1 Oct 2008 20:05:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081001180539.GA25759@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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
J.A. Magallón (1):
      x86: fix typo in enable_mtrr_cleanup early parameter

Zachary Amsden (1):
      x86, vmi: fix broken LDT access


 arch/x86/kernel/cpu/mtrr/main.c |    2 +-
 arch/x86/kernel/vmi_32.c        |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index b117d7f..885c826 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -834,7 +834,7 @@ static int __init enable_mtrr_cleanup_setup(char *str)
 		enable_mtrr_cleanup = 1;
 	return 0;
 }
-early_param("enble_mtrr_cleanup", enable_mtrr_cleanup_setup);
+early_param("enable_mtrr_cleanup", enable_mtrr_cleanup_setup);
 
 struct var_mtrr_state {
 	unsigned long	range_startk;
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 6ca515d..edfb09f 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -235,7 +235,7 @@ static void vmi_write_ldt_entry(struct desc_struct *dt, int entry,
 				const void *desc)
 {
 	u32 *ldt_entry = (u32 *)desc;
-	vmi_ops.write_idt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
+	vmi_ops.write_ldt_entry(dt, entry, ldt_entry[0], ldt_entry[1]);
 }
 
 static void vmi_load_sp0(struct tss_struct *tss,
