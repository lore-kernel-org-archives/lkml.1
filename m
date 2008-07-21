Return-Path: <linux-kernel-owner+w=401wt.eu-S1756135AbYGUXuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbYGUXuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754185AbYGUXuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:50:07 -0400
Received: from gw.goop.org ([64.81.55.164]:33964 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbYGUXuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:50:06 -0400
Message-ID: <488520A2.1080701@goop.org>
Date: Mon, 21 Jul 2008 16:49:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark McLoughlin <markmc@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] x86: call early_cpu_init at the same point
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call early_cpu_init() at the same (early) point in setup_arch().
The x86_64 code was calling it relatively late, after when other arch
code need to do cpu-related setup which depends on it.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/kernel/setup.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

===================================================================
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -597,11 +597,11 @@
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
 	visws_early_detect();
 	pre_setup_arch_hook();
-	early_cpu_init();
 #else
 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
 #endif
 
+	early_cpu_init();
 	early_ioremap_init();
 
 	ROOT_DEV = old_decode_dev(boot_params.hdr.root_dev);
@@ -665,9 +665,6 @@
 	bss_resource.start = virt_to_phys(&__bss_start);
 	bss_resource.end = virt_to_phys(&__bss_stop)-1;
 
-#ifdef CONFIG_X86_64
-	early_cpu_init();
-#endif
 	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
 	*cmdline_p = command_line;
 


