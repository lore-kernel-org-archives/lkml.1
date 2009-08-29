Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZH2Q0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZH2Q0s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 12:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbZH2Q0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 12:26:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbZH2Q0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 12:26:47 -0400
Date: Sat, 29 Aug 2009 18:27:18 +0200
From: Michal Schmidt <mschmidt@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: detect stack protector for i386 builds on x86_64
Message-ID: <20090829182718.10f566b1@leela>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stack protector support was not detected when building with ARCH=i386
on x86_64 systems:
arch/x86/Makefile:80: stack protector enabled but no compiler support

The "-m32" argument needs to be passed to the detection script.

Signed-off-by: Michal Schmidt <mschmidt@redhat.com>

--
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 1b68659..5e7db44 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -72,7 +72,7 @@ endif
 
 ifdef CONFIG_CC_STACKPROTECTOR
 	cc_has_sp := $(srctree)/scripts/gcc-x86_$(BITS)-has-stack-protector.sh
-        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC)),y)
+        ifeq ($(shell $(CONFIG_SHELL) $(cc_has_sp) $(CC) $(biarch)),y)
                 stackp-y := -fstack-protector
                 stackp-$(CONFIG_CC_STACKPROTECTOR_ALL) += -fstack-protector-all
                 KBUILD_CFLAGS += $(stackp-y)
