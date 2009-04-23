Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZDWHvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZDWHvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 03:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757306AbZDWHdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 03:33:37 -0400
Received: from sous-sol.org ([216.99.217.87]:50950 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757290AbZDWHdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 03:33:36 -0400
Message-Id: <20090423072950.513867611@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Thu, 23 Apr 2009 00:21:43 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, chrisw@redhat.com
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, mtosatti@redhat.com,
       Avi Kivity <avi@redhat.com>
Subject: [patch 083/100] KVM: Add CONFIG_HAVE_KVM_IRQCHIP
References: <20090423072020.428683652@sous-sol.org>
Content-Disposition: inline; filename=kvm-add-config_have_kvm_irqchip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Avi Kivity <avi@redhat.com>

upstream commit: 5d9b8e30f543a9f21a968a4cda71e8f6d1c66a61

Two KVM archs support irqchips and two don't.  Add a Kconfig item to
make selecting between the two models easier.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 arch/ia64/kvm/Kconfig    |    4 ++++
 arch/powerpc/kvm/Kconfig |    3 +++
 arch/s390/kvm/Kconfig    |    3 +++
 arch/x86/kvm/Kconfig     |    4 ++++
 4 files changed, 14 insertions(+)

--- a/arch/ia64/kvm/Kconfig
+++ b/arch/ia64/kvm/Kconfig
@@ -4,6 +4,10 @@
 config HAVE_KVM
 	bool
 
+config HAVE_KVM_IRQCHIP
+       bool
+       default y
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	depends on HAVE_KVM || IA64
--- a/arch/powerpc/kvm/Kconfig
+++ b/arch/powerpc/kvm/Kconfig
@@ -2,6 +2,9 @@
 # KVM configuration
 #
 
+config HAVE_KVM_IRQCHIP
+       bool
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	---help---
--- a/arch/s390/kvm/Kconfig
+++ b/arch/s390/kvm/Kconfig
@@ -4,6 +4,9 @@
 config HAVE_KVM
        bool
 
+config HAVE_KVM_IRQCHIP
+       bool
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	default y
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -4,6 +4,10 @@
 config HAVE_KVM
        bool
 
+config HAVE_KVM_IRQCHIP
+       bool
+       default y
+
 menuconfig VIRTUALIZATION
 	bool "Virtualization"
 	depends on HAVE_KVM || X86

