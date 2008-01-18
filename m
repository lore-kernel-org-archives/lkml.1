Return-Path: <linux-kernel-owner+w=401wt.eu-S1763764AbYARR0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763764AbYARR0p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:26:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759404AbYARR0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:26:35 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:41972 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763598AbYARR0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:26:34 -0500
Date: Fri, 18 Jan 2008 22:56:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: 2.6.24-rc8-mm1 (KVM build issues)
Message-ID: <20080118172632.GB12009@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080117023514.9df393cf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton <akpm@linux-foundation.org> [2008-01-17 02:35:14]:

> - kvm probably doesn't work properly because I couldn't be bothered fixing
>   the conflicts between git-kvm and the driver tree
> 

Hi, Andrew,

The following changes got KVM up and running for me


This patch fixes the kvm build on 2.6.24-rc8-mm1. First of all, it enables
the KVM build, the second fix moves kset_set_name to the .name member.

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/x86/Makefile   |    2 +-
 virt/kvm/kvm_main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/Makefile~fix-kvm-build arch/x86/Makefile
--- linux-2.6.24-rc8/arch/x86/Makefile~fix-kvm-build	2008-01-18 22:42:41.000000000 +0530
+++ linux-2.6.24-rc8-balbir/arch/x86/Makefile	2008-01-18 22:42:47.000000000 +0530
@@ -185,7 +185,7 @@ core-y += arch/x86/vdso/
 core-$(CONFIG_IA32_EMULATION) += arch/x86/ia32/
 
 # kvm host support - uncomment when merging
-# core-$(CONFIG_KVM) += arch/x86/kvm/
+core-$(CONFIG_KVM) += arch/x86/kvm/
 
 # drivers-y are linked after core-y
 drivers-$(CONFIG_MATH_EMULATION) += arch/x86/math-emu/
diff -puN virt/kvm/kvm_main.c~fix-kvm-build virt/kvm/kvm_main.c
--- linux-2.6.24-rc8/virt/kvm/kvm_main.c~fix-kvm-build	2008-01-18 22:42:41.000000000 +0530
+++ linux-2.6.24-rc8-balbir/virt/kvm/kvm_main.c	2008-01-18 22:42:47.000000000 +0530
@@ -1260,7 +1260,7 @@ static int kvm_resume(struct sys_device 
 }
 
 static struct sysdev_class kvm_sysdev_class = {
-	set_kset_name("kvm"),
+	.name = "kvm",
 	.suspend = kvm_suspend,
 	.resume = kvm_resume,
 };
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
