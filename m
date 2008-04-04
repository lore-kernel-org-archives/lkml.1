Return-Path: <linux-kernel-owner+w=401wt.eu-S1760643AbYDDSxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643AbYDDSxh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbYDDSxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:53:16 -0400
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:22214 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245AbYDDSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:53:15 -0400
Date: Fri, 4 Apr 2008 20:51:47 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] Build fix for uml/x86_64
Message-ID: <20080404185147.GB8989@mailshack.com>
References: <20080404184930.GA8978@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080404184930.GA8978@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Fri, 04 Apr 2008 20:53:02 +0200 (CEST)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.81; VDF: 7.0.3.121; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build fix for uml/x86_64, which was broken by:
x86: remove x86-specific implementations of find_first_bit

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

---

Hi Ingo,

I broke uml again :(

This patch fixes the problem for x86_64. These changes
should have been included in:

x86: switch x86_64 to generic find_first_bit

Greetings,
        Alexander

 arch/um/Kconfig.x86_64      |    4 ++++
 arch/um/sys-x86_64/Makefile |    2 +-
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/um/Kconfig.x86_64 b/arch/um/Kconfig.x86_64
index a29f545..84cefd5 100644
--- a/arch/um/Kconfig.x86_64
+++ b/arch/um/Kconfig.x86_64
@@ -31,6 +31,10 @@ config SMP_BROKEN
 	bool
 	default y
 
+config GENERIC_FIND_FIRST_BIT
+	bool
+	default y
+
 config GENERIC_FIND_NEXT_BIT
 	bool
 	default y
diff --git a/arch/um/sys-x86_64/Makefile b/arch/um/sys-x86_64/Makefile
index 3c22de5..c8b4cce 100644
--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -10,7 +10,7 @@ obj-y = bug.o bugs.o delay.o fault.o ldt.o mem.o ptrace.o ptrace_user.o \
 
 obj-$(CONFIG_MODULES) += um_module.o
 
-subarch-obj-y = lib/bitops_64.o lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
+subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module_64.o
 
 ldt-y = ../sys-i386/ldt.o
