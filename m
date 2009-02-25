Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbZBYVp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbZBYVp7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 16:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758075AbZBYVpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 16:45:50 -0500
Received: from movementarian.org ([79.99.65.163]:42088 "EHLO movementarian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362AbZBYVpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 16:45:50 -0500
Date: Wed, 25 Feb 2009 16:45:42 -0500
From: wli@movementarian.org
To: linux-kernel@vger.kernel.org
Cc: Mark Langsdorf <mark.langsdorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Lammerts <eric@lammerts.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] mm: k8_northbridges[] build fix
Message-ID: <20090225214542.GB5757@movementarian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

k8_northbridges[] isn't a defined symbol unless arch/x86/kernel/k8.c
is compiled, which is conditional on CONFIG_K8_NB. This patch resolves
the link error by making the sysfs access to the k8 northbridge
conditional on CONFIG_K8_NB in like fashion to the k8_northbridges[]
array itself. The issue was encountered on a 32-bit build with the
processor family specified as CONFIG_MCORE2=y.

The link error was introduced in
	x86-conform-l3-cache-index-disable-to-linux-standards.patch

Signed-off-by: William Irwin <wli@movementarian.org>


Index: mmotm-2.6.29-rc6/arch/x86/kernel/cpu/intel_cacheinfo.c
===================================================================
--- mmotm-2.6.29-rc6.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ mmotm-2.6.29-rc6/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -613,7 +613,7 @@ static int __cpuinit detect_cache_attrib
 	return retval;
 }
 
-#ifdef CONFIG_SYSFS
+#if defined(CONFIG_SYSFS) && defined(CONFIG_K8_NB)
 
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
@@ -986,4 +986,4 @@ static int __cpuinit cache_sysfs_init(vo
 
 device_initcall(cache_sysfs_init);
 
-#endif
+#endif /* defined(CONFIG_SYSFS) && defined(CONFIG_K8_NB) */
