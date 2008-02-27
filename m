Return-Path: <linux-kernel-owner+w=401wt.eu-S1756598AbYB0N4y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598AbYB0N4y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:56:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbYB0N4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:56:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:56847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751391AbYB0N4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:56:45 -0500
To: linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org,
       Jeremy Fitzhardinge <jeremy@goop.org>, mingo@redhat.com
Subject: xen: Make hvc0 the preferred console in domU
From: Markus Armbruster <armbru@redhat.com>
Date: Wed, 27 Feb 2008 14:56:35 +0100
Message-ID: <87zltm1p0s.fsf@pike.pond.sub.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the Xen console just work.  Before, you had to ask for it
on the kernel command line with console=hvc0

Signed-off-by: Markus Armbruster <armbru@redhat.com>

---
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 49e5358..df63185 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -25,6 +25,7 @@
 #include <linux/mm.h>
 #include <linux/page-flags.h>
 #include <linux/highmem.h>
+#include <linux/console.h>
 
 #include <xen/interface/xen.h>
 #include <xen/interface/physdev.h>
@@ -1209,6 +1210,9 @@ asmlinkage void __init xen_start_kernel(void)
 		? __pa(xen_start_info->mod_start) : 0;
 	boot_params.hdr.ramdisk_size = xen_start_info->mod_len;
 
+	if (!is_initial_xendomain())
+		add_preferred_console("hvc", 0, NULL);
+
 	/* Start the world */
 	start_kernel();
 }
