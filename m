Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYAVS6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYAVS6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 13:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbYAVS6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 13:58:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbYAVS6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 13:58:05 -0500
Date: Tue, 22 Jan 2008 16:52:40 -0200
From: Eduardo Pereira Habkost <ehabkost@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: [PATCH 2/2] Remove depends on X86_32 from PARAVIRT & PARAVIRT_GUEST
Message-ID: <20080122185239.GZ7338@blackpad>
References: <1200952133-31581-1-git-send-email-ehabkost@redhat.com> <20080122120207.GA30271@elte.hu> <20080122123450.GU7338@blackpad> <47962E1D.2090308@goop.org> <20080122185018.GY7338@blackpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080122185018.GY7338@blackpad>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With this, the paravirt_ops code can be enabled on x86_64 also.

Each guest implementation (Xen, VMI, lguest) now depends on X86_32. The
dependencies can be dropped for each one when they start to support
x86_64.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 arch/x86/Kconfig        |    4 ++--
 arch/x86/lguest/Kconfig |    1 +
 arch/x86/xen/Kconfig    |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 715bbcd..43d535a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -327,7 +327,6 @@ config SCHED_NO_NO_OMIT_FRAME_POINTER
 
 menuconfig PARAVIRT_GUEST
 	bool "Paravirtualized guest support"
-	depends on X86_32
 	help
 	  Say Y here to get to see options related to running Linux under
 	  various hypervisors.  This option alone does not add any kernel code.
@@ -341,6 +340,7 @@ source "arch/x86/xen/Kconfig"
 config VMI
 	bool "VMI Guest support"
 	select PARAVIRT
+	depends on X86_32
 	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
@@ -352,7 +352,7 @@ source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
 	bool "Enable paravirtualization code"
-	depends on X86_32 && !(X86_VISWS || X86_VOYAGER)
+	depends on !(X86_VISWS || X86_VOYAGER)
 	help
 	  This changes the kernel so it can modify itself when it is run
 	  under a hypervisor, potentially improving performance significantly
diff --git a/arch/x86/lguest/Kconfig b/arch/x86/lguest/Kconfig
index 19626ac..964dfa3 100644
--- a/arch/x86/lguest/Kconfig
+++ b/arch/x86/lguest/Kconfig
@@ -1,6 +1,7 @@
 config LGUEST_GUEST
 	bool "Lguest guest support"
 	select PARAVIRT
+	depends on X86_32
 	depends on !X86_PAE
 	depends on !(X86_VISWS || X86_VOYAGER)
 	select VIRTIO
diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index fbfa55c..4d5f264 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -5,6 +5,7 @@
 config XEN
 	bool "Xen guest support"
 	select PARAVIRT
+	depends on X86_32
 	depends on X86_CMPXCHG && X86_TSC && !NEED_MULTIPLE_NODES && !(X86_VISWS || X86_VOYAGER)
 	help
 	  This is the Linux Xen port.  Enabling this will allow the
-- 
1.5.3.4
