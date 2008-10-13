Return-Path: <linux-kernel-owner+w=401wt.eu-S1760639AbYJMSyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760639AbYJMSyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbYJMSyg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:54:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:10535 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbYJMSyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N7hhTllN3ENeX0pRoSKynMHHNYPoD/GazoeRBFleoG4i9Jej+XpG0H0zu0Fcxcu5o7
         k/CYdngZPIK6v2ZMde+HAYuaPFzkyRUsZTAzbGSdwMiZW++O+oZxR/AbSKFLa2gSiiYL
         VqJHkpjnlVbgSPhNrBMeRuoh4/klJHqQ+y05s=
Date: Mon, 13 Oct 2008 20:53:53 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] x86: dmi_low_memory_corruption is used only when
	CONFIG_X86_RESERVE_LOW_64K is enabled
Message-ID: <20081013185311.GB5676@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes following compilation warning:

arch/x86/kernel/setup.c:736: warning: 'dmi_low_memory_corruption' defined but not used

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 21b8e0a..1b565b6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -732,6 +732,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -743,6 +744,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
