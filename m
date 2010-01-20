Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368Ab0ATPkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0ATPkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 10:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932Ab0ATPkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 10:40:31 -0500
Received: from bounce-out.estpak.ee ([194.126.126.40]:49234 "EHLO
	bounce-out.neti.ee" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753266Ab0ATPk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 10:40:29 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Jan 2010 10:40:28 EST
X-SMTP-Auth-NETI-Businessmail: no
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] powernow-k8: On load failure,
	remind the user to enable support in BIOS setup
X-Mercurial-Node: 160211accaba09e778c6dfe9caad81e05ee83387
Message-Id: <160211accaba09e778c6.1264001606@newn>
User-Agent: Mercurial-patchbomb/1.4.2
Date: Wed, 20 Jan 2010 17:33:26 +0200
From: Marti Raudsepp <marti@juffo.org>
To: cpufreq@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Thomas Renninger <trenn@suse.de>,
       Mark Langsdorf <mark.langsdorf@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |  15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)


In most cases this is simply user error or bad BIOS defaults, rather than a
firmware problem.

Signed-off-by: Marti Raudsepp <marti@juffo.org>

diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -789,17 +789,20 @@
 				(struct pst_s *)(psb+1), maxvid);
 	}
 	/*
-	 * If you see this message, complain to BIOS manufacturer. If
-	 * he tells you "we do not support Linux" or some similar
-	 * nonsense, remember that Windows 2000 uses the same legacy
-	 * mechanism that the old Linux PSB driver uses. Tell them it
-	 * is broken with Windows 2000.
+	 * If you see this message, check that Cool'N'Quiet is enabled
+	 * in your BIOS setup. If that fails, complain to your BIOS
+	 * manufacturer. If he tells you "we do not support Linux" or
+	 * some similar nonsense, remember that Windows 2000 uses the
+	 * same legacy mechanism that the old Linux PSB driver uses.
+	 * Tell them it is broken with Windows 2000.
 	 *
 	 * The reference to the AMD documentation is chapter 9 in the
 	 * BIOS and Kernel Developer's Guide, which is available on
 	 * www.amd.com
 	 */
-	printk(KERN_ERR FW_BUG PFX "No PSB or ACPI _PSS objects\n");
+	printk(KERN_ERR PFX "No PSB or ACPI _PSS objects\n");
+	printk(KERN_ERR PFX "Make sure that Cool'N'Quiet support is "
+		"enabled in your BIOS setup\n");
 	return -ENODEV;
 }
 
