Return-Path: <linux-kernel-owner+w=401wt.eu-S1753340AbZCVIRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340AbZCVIRA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 04:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZCVIQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 04:16:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:51719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZCVIQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 04:16:43 -0400
Subject: [PATCH -tip] x86: cpu/cpu.h cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Mar 2009 13:46:16 +0530
Message-Id: <1237709776.909.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

Is it worth to move arch/x86/kernel/cpu/cpu.h data to asm/cpu.h and if
required we can also make it private like:
#ifdef __KERNEL__
#ifndef MODULE
private data for kernel only
#endif
#endif

By this way we move header files to include directory. Or you have some
better option.

From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Sun, 22 Mar 2009 13:28:39 +0530
Subject: [PATCH] x86: cpu/cpu.h cleanup

Impact: cleanup

 - Fix various style issues

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/cpu.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index 9469ecb..6de9a90 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -3,25 +3,25 @@
 #define ARCH_X86_CPU_H
 
 struct cpu_model_info {
-	int vendor;
-	int family;
-	const char *model_names[16];
+	int		vendor;
+	int		family;
+	const char	*model_names[16];
 };
 
 /* attempt to consolidate cpu attributes */
 struct cpu_dev {
-	const char	* c_vendor;
+	const char	*c_vendor;
 
 	/* some have two possibilities for cpuid string */
-	const char	* c_ident[2];
+	const char	*c_ident[2];
 
 	struct		cpu_model_info c_models[4];
 
-	void            (*c_early_init)(struct cpuinfo_x86 *c);
-	void		(*c_init)(struct cpuinfo_x86 * c);
-	void		(*c_identify)(struct cpuinfo_x86 * c);
-	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
-	int	c_x86_vendor;
+	void            (*c_early_init)(struct cpuinfo_x86 *);
+	void		(*c_init)(struct cpuinfo_x86 *);
+	void		(*c_identify)(struct cpuinfo_x86 *);
+	unsigned int	(*c_size_cache)(struct cpuinfo_x86 *, unsigned int);
+	int		c_x86_vendor;
 };
 
 #define cpu_dev_register(cpu_devX) \
-- 
1.6.0.6



