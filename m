Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbYJWXUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbYJWXUI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYJWXT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:19:56 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:39549 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYJWXT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:19:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=TqHX5R+1PS0yC/+fPyDMpdCkEBI2/Uqc2hbNXi7bKxEWemhso0sEHPyFo9gVxG8yne
         DYxTkjfcQdz6YXVq9XTmKkFY7TpTloxwk4FL9WLkWZUye60YEo7P4DMjM75FT3zRQ7e3
         l+60R5pFPje7FvygsShNp6C8WzE6fbNjCoJxA=
Date: Fri, 24 Oct 2008 03:19:43 +0400
From: Alexander Beregalov <a.beregalov@gmail.com>
To: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/kernel/setup.c: fix warning dmi_low_memory_corruption
	defined but not used
Message-ID: <20081023231943.GA14519@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---

 arch/x86/kernel/setup.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..ce892b0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -738,6 +738,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -752,7 +753,6 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
-#ifdef CONFIG_X86_RESERVE_LOW_64K
 	{
 		.callback = dmi_low_memory_corruption,
 		.ident = "AMI BIOS",
@@ -767,9 +767,13 @@ static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
 		},
 	},
-#endif
 	{}
 };
+#else
+static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
+	{}
+};
+#endif
 
 /*
  * Determine if we were loaded by an EFI loader.  If so, then we have also been
