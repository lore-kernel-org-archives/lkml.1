Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYDDSxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYDDSxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757235AbYDDSxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:53:15 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:22208 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbYDDSxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:53:14 -0400
Date: Fri, 4 Apr 2008 20:51:06 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] Build fix for uml/i386
Message-ID: <20080404185106.GA8989@mailshack.com>
References: <20080404184930.GA8978@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404184930.GA8978@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Fri, 04 Apr 2008 20:53:01 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.121; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build fix for uml/i386, which was broken by:
x86: remove x86-specific implementations of find_first_bit

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi Ingo,

I broke uml again :(

This patch fixes the problem for i386. These changes should
have been included in:

x86: generic versions of find_first_(zero_)bit, convert i386

Greetings,
	Alexander

 arch/um/Kconfig.i386      |    4 ++++
 arch/um/sys-i386/Makefile |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/um/Kconfig.i386 b/arch/um/Kconfig.i386
index 164d29c..f694cff 100644
--- a/arch/um/Kconfig.i386
+++ b/arch/um/Kconfig.i386
@@ -43,6 +43,10 @@ config ARCH_REUSE_HOST_VSYSCALL_AREA
 	bool
 	default y
 
+config GENERIC_FIND_FIRST_BIT
+	bool
+	default y
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff --git a/arch/um/sys-i386/Makefile b/arch/um/sys-i386/Makefile
index 964dc1a..598b5c1 100644
--- a/arch/um/sys-i386/Makefile
+++ b/arch/um/sys-i386/Makefile
@@ -6,7 +6,7 @@ obj-y = bug.o bugs.o checksum.o delay.o fault.o ksyms.o ldt.o ptrace.o \
 	ptrace_user.o setjmp.o signal.o stub.o stub_segv.o syscalls.o sysrq.o \
 	sys_call_table.o tls.o
 
-subarch-obj-y = lib/bitops_32.o lib/semaphore_32.o lib/string_32.o
+subarch-obj-y = lib/semaphore_32.o lib/string_32.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem_32.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module_32.o
 

