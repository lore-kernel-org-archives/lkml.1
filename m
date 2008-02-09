Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYBIU73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYBIU73 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 15:59:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbYBIU7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 15:59:20 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:57203 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbYBIU7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 15:59:19 -0500
Subject: [PATCH] make KVM selectable again
From: Dave Hansen <haveblue@us.ibm.com>
To: Avi Kivity <avi@argo.co.il>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 12:59:15 -0800
Message-Id: <1202590755.14165.11.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current git for me (b1d0e4f535e10775cffde922208b49629169aeaa) doesn't
let me build KVM.  In fact, I don't seem to have *ANY* kvm-related
symbols in my .config at all.

I've verified that arch/x86/kvm/Kconfig was getting run by putting some
comments in it.  It seems to me like just putting:

	config HAVE_KVM
	       bool

isn't letting anything come into my .config at all.  I'm not sure why we
do that, and then have:

	select HAVE_KVM

in arch/x86/Kconfig.

This patch just defines HAVE_KVM in the x86 Kconfig and is done with it.
Seems to work for me.

Was there some reason that it was done this way?  Was it ever tested?

-- Dave

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 65a70b7..cbbf35d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -115,7 +115,8 @@ config ARCH_HAS_CPU_RELAX
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
-select HAVE_KVM
+config HAVE_KVM
+	def_bool y
 
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 41962e7..f2177ec 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -1,8 +1,6 @@
 #
 # KVM configuration
 #
-config HAVE_KVM
-       bool
 
 menuconfig VIRTUALIZATION
 	bool "Virtualization"


