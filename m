Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbYHJWLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbYHJWLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 18:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYHJWLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 18:11:37 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:38064 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbYHJWLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 18:11:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=MplwGeG1ePplqtxhKkZMA6+pmOI+5caSzSEdpkk9XIvIBVFXCjrak8mLWhGsQd/JBM
         0HjeU1roz+akDM0anw/u7pdcpISDtU0VHkn8OokLFnuJ5sbde7x4BQOuvbHAm9m18ej+
         q+x6tNua3H3//93m/mFo/Bu0zXjS2MDtiwEys=
Date: Mon, 11 Aug 2008 00:11:13 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: [PATCH] x86: mmconf: fix section mismatch warning
Message-ID: <20080810221109.GC27349@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x1591): Section mismatch in reference from the function init_amd() to the function .init.text:check_enable_amd_mmconf_dmi()
The function __cpuinit init_amd() references
a function __init check_enable_amd_mmconf_dmi().
If check_enable_amd_mmconf_dmi is only used by init_amd then
annotate check_enable_amd_mmconf_dmi with a matching annotation.

check_enable_amd_mmconf_dmi is only called from init_amd which is __cpuinit

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/mmconf-fam10h_64.c |    2 +-
 include/asm-x86/mmconfig.h         |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index fdfdc55..efc2f36 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -238,7 +238,7 @@ static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
 	{}
 };
 
-void __init check_enable_amd_mmconf_dmi(void)
+void __cpuinit check_enable_amd_mmconf_dmi(void)
 {
 	dmi_check_system(mmconf_dmi_table);
 }
diff --git a/include/asm-x86/mmconfig.h b/include/asm-x86/mmconfig.h
index 95beda0..e293ab8 100644
--- a/include/asm-x86/mmconfig.h
+++ b/include/asm-x86/mmconfig.h
@@ -3,7 +3,7 @@
 
 #ifdef CONFIG_PCI_MMCONFIG
 extern void __cpuinit fam10h_check_enable_mmcfg(void);
-extern void __init check_enable_amd_mmconf_dmi(void);
+extern void __cpuinit check_enable_amd_mmconf_dmi(void);
 #else
 static inline void fam10h_check_enable_mmcfg(void) { }
 static inline void check_enable_amd_mmconf_dmi(void) { }
-- 
1.5.4.5

