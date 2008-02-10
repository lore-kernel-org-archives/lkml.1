Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbYBJHS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbYBJHS4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:18:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755951AbYBJHSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:18:46 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:60986 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484AbYBJHSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:18:44 -0500
Date: Sun, 10 Feb 2008 12:46:28 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Avi Kivity <avi@qumranet.com>
Subject: KVM is not seen under X86 config with latest git (32 bit compile)
Message-ID: <20080210071628.GA27409@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux kernel mailing list <linux-kernel@vger.kernel.org>,
	Avi Kivity <avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The KVM configuration is no longer visible in the latest git tree. It looks
like it is selected by HAVE_SETUP_PER_CPU_AREA. I've moved HAVE_KVM to
under CONFIG_X86. Hopefully, this is the right fix.

Comments?

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 arch/x86/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/Kconfig~fix-kvm-build arch/x86/Kconfig
--- linux-2.6-git/arch/x86/Kconfig~fix-kvm-build	2008-02-10 12:41:18.000000000 +0530
+++ linux-2.6-git-balbir/arch/x86/Kconfig	2008-02-10 12:41:37.000000000 +0530
@@ -20,6 +20,8 @@ config X86
 	def_bool y
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
+	select HAVE_KVM
+
 
 config GENERIC_LOCKBREAK
 	def_bool n
@@ -108,8 +110,6 @@ config GENERIC_TIME_VSYSCALL
 config HAVE_SETUP_PER_CPU_AREA
 	def_bool X86_64
 
-select HAVE_KVM
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 	depends on !SMP || !X86_VOYAGER
_
-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
