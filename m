Return-Path: <linux-kernel-owner+w=401wt.eu-S1758632AbZJHUZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632AbZJHUZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 16:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbZJHUZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 16:25:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:53628 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbZJHUZy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 16:25:54 -0400
Date: Thu, 8 Oct 2009 20:24:45 GMT
From: tip-bot for Alok Kataria <akataria@vmware.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       chrisw@sous-sol.org, akataria@vmware.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       chrisw@sous-sol.org, tglx@linutronix.de, akataria@vmware.com
In-Reply-To: <1254193238.13456.48.camel@ank32.eng.vmware.com>
References: <1254193238.13456.48.camel@ank32.eng.vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, vmi: Mark VMI deprecated and schedule it for remval
Message-ID: <tip-6c42ffab4dc0e21f9c6adc906368e7e7c12df47f@git.kernel.org>
Git-Commit-ID: 6c42ffab4dc0e21f9c6adc906368e7e7c12df47f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 08 Oct 2009 20:24:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c42ffab4dc0e21f9c6adc906368e7e7c12df47f
Gitweb:     http://git.kernel.org/tip/6c42ffab4dc0e21f9c6adc906368e7e7c12df47f
Author:     Alok Kataria <akataria@vmware.com>
AuthorDate: Tue, 29 Sep 2009 10:25:24 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 8 Oct 2009 13:21:04 -0700

x86, vmi: Mark VMI deprecated and schedule it for remval

Add text in feature-removal.txt indicating that VMI will be removed in
the 2.6.37 timeframe, and modify Kconfig to disable VMI by default.

[ hpa: removed a bogus Kconfig change, marked (DEPRECATED) in Kconfig ]

Signed-off-by: Alok N Kataria <akataria@vmware.com>
Acked-by: Chris Wright <chrisw@sous-sol.org>
LKML-Reference: <1254193238.13456.48.camel@ank32.eng.vmware.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 Documentation/feature-removal-schedule.txt |   30 ++++++++++++++++++++++++++++
 arch/x86/Kconfig                           |   11 +++++++++-
 arch/x86/kernel/vmi_32.c                   |    2 +-
 3 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 89a47b5..04e6c81 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -451,3 +451,33 @@ Why:	OSS sound_core grabs all legacy minors (0-255) of SOUND_MAJOR
 	will also allow making ALSA OSS emulation independent of
 	sound_core.  The dependency will be broken then too.
 Who:	Tejun Heo <tj@kernel.org>
+
+----------------------------
+
+What:	Support for VMware's guest paravirtuliazation technique [VMI] will be
+	dropped.
+When:	2.6.37 or earlier.
+Why:	With the recent innovations in CPU hardware acceleration technologies
+	from Intel and AMD, VMware ran a few experiments to compare these
+	techniques to guest paravirtualization technique on VMware's platform.
+	These hardware assisted virtualization techniques have outperformed the
+	performance benefits provided by VMI in most of the workloads. VMware
+	expects that these hardware features will be ubiquitous in a couple of
+	years, as a result, VMware has started a phased retirement of this
+	feature from the hypervisor. We will be removing this feature from the
+	Kernel too. Right now we are targeting 2.6.37 but can retire earlier if
+	technical reasons (read opportunity to remove major chunk of pvops)
+	arise.
+
+	Please note that VMI has always been an optimization and non-VMI kernels
+	still work fine on VMware's platform.
+	Latest versions of VMware's product which support VMI are,
+	Workstation 7.0 and VSphere 4.0 on ESX side, future maintainence
+	releases for these products will continue supporting VMI.
+
+	For more details about VMI retirement take a look at this,
+	http://blogs.vmware.com/guestosguide/2009/09/vmi-retirement.html
+
+Who:	Alok N Kataria <akataria@vmware.com>
+
+----------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c876bac..07e0114 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -491,7 +491,7 @@ if PARAVIRT_GUEST
 source "arch/x86/xen/Kconfig"
 
 config VMI
-	bool "VMI Guest support"
+	bool "VMI Guest support (DEPRECATED)"
 	select PARAVIRT
 	depends on X86_32
 	---help---
@@ -500,6 +500,15 @@ config VMI
 	  at the moment), by linking the kernel to a GPL-ed ROM module
 	  provided by the hypervisor.
 
+	  As of September 2009, VMware has started a phased retirement
+	  of this feature from VMware's products. Please see
+	  feature-removal-schedule.txt for details.  If you are
+	  planning to enable this option, please note that you cannot
+	  live migrate a VMI enabled VM to a future VMware product,
+	  which doesn't support VMI. So if you expect your kernel to
+	  seamlessly migrate to newer VMware products, keep this
+	  disabled.
+
 config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 31e6f6c..d430e4c 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -648,7 +648,7 @@ static inline int __init activate_vmi(void)
 
 	pv_info.paravirt_enabled = 1;
 	pv_info.kernel_rpl = kernel_cs & SEGMENT_RPL_MASK;
-	pv_info.name = "vmi";
+	pv_info.name = "vmi [deprecated]";
 
 	pv_init_ops.patch = vmi_patch;
 
