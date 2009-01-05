Return-Path: <linux-kernel-owner+w=401wt.eu-S1751610AbZAEFGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbZAEFGk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 00:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbZAEFGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 00:06:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:33110 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbZAEFGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 00:06:31 -0500
Subject: Re: [PATCH -tip] x86: setup.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090104203433.GC1132@elte.hu>
References: <1231066898.27852.29.camel@jaswinder.satnam>
	 <20090104172114.GA32425@elte.hu>
	 <3f9a31f40901040957g5a391408u5cda93c4acb66e9d@mail.gmail.com>
	 <20090104203433.GC1132@elte.hu>
Content-Type: text/plain
Date: Mon, 05 Jan 2009 10:34:15 +0530
Message-Id: <1231131855.16019.2.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 21:34 +0100, Ingo Molnar wrote:
> yeah - i mentioned it to you before that there are such cases.
> 

OK, so here is new patch excluding smp.h:

[PATCH]  x86: setup.c fix style problems

Impact: cleanup

Fix:

WARNING: Use #include <linux/percpu.h> instead of <asm/percpu.h>
WARNING: Use #include <linux/topology.h> instead of <asm/topology.h>
WARNING: externs should be avoided in .c files
ERROR: code indent should use tabs where possible

total: 2 errors, 3 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/setup.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ae0d804..57e76ca 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -66,6 +66,7 @@
 
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
+#include <linux/topology.h>
 
 #include <video/edid.h>
 
@@ -101,8 +102,6 @@
 #include <asm/paravirt.h>
 #include <asm/hypervisor.h>
 
-#include <asm/percpu.h>
-#include <asm/topology.h>
 #include <asm/apicdef.h>
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
@@ -216,8 +215,6 @@ EXPORT_SYMBOL(screen_info);
 struct edid_info edid_info;
 EXPORT_SYMBOL_GPL(edid_info);
 
-extern int root_mountflags;
-
 unsigned long saved_video_mode;
 
 #define RAMDISK_IMAGE_START_MASK	0x07FF
@@ -823,8 +820,8 @@ void __init setup_arch(char **cmdline_p)
 #else
 	num_physpages = max_pfn;
 
- 	if (cpu_has_x2apic)
- 		check_x2apic();
+	if (cpu_has_x2apic)
+		check_x2apic();
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
-- 
1.5.6.6




