Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYKTLWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYKTLWn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:22:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYKTLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:22:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52040 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbYKTLWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:22:33 -0500
Date: Thu, 20 Nov 2008 12:22:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20081120112218.GA13019@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Hiroshi Shimamoto (1):
      x86: uaccess_64: fix return value in __copy_from_user()

Steve Conklin (1):
      x86: quirk for reboot stalls on a Dell Optiplex 330


 arch/x86/include/asm/uaccess_64.h |    2 +-
 arch/x86/kernel/reboot.c          |    9 +++++++++
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 664f152..f8cfd00 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -46,7 +46,7 @@ int __copy_from_user(void *dst, const void __user *src, unsigned size)
 		return ret;
 	case 10:
 		__get_user_asm(*(u64 *)dst, (u64 __user *)src,
-			       ret, "q", "", "=r", 16);
+			       ret, "q", "", "=r", 10);
 		if (unlikely(ret))
 			return ret;
 		__get_user_asm(*(u16 *)(8 + (char *)dst),
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 724adfc..cc5a254 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -169,6 +169,15 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "0KW626"),
 		},
 	},
+	{   /* Handle problems with rebooting on Dell Optiplex 330 with 0KP561 */
+		.callback = set_bios_reboot,
+		.ident = "Dell OptiPlex 330",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 330"),
+			DMI_MATCH(DMI_BOARD_NAME, "0KP561"),
+		},
+	},
 	{	/* Handle problems with rebooting on Dell 2400's */
 		.callback = set_bios_reboot,
 		.ident = "Dell PowerEdge 2400",
