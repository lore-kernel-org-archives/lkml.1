Return-Path: <linux-kernel-owner+w=401wt.eu-S935026AbZAOWRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935026AbZAOWRs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 17:17:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933708AbZAOWC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 17:02:27 -0500
Received: from kroah.org ([198.145.64.141]:38367 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765602AbZAOWCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 17:02:18 -0500
Date: Thu, 15 Jan 2009 13:59:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 28/85] [PATCH 08/44] [CVE-2009-0029] powerpc: Enable
	syscall wrappers for 64-bit
Message-ID: <20090115215952.GC17227@kroah.com>
References: <20090115215237.906089480@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0008--CVE-2009-0029-powerpc-Enable-syscall-wrappers-for.patch"
In-Reply-To: <20090115215812.GA17227@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit ee6a093222549ac0c72cfd296c69fa5e7d6daa34 upstream.

This enables the use of syscall wrappers to do proper sign extension
for 64-bit programs.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/Kconfig     |    1 +
 include/linux/syscalls.h |    6 ++++++
 2 files changed, 7 insertions(+)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -122,6 +122,7 @@ config PPC
 	select HAVE_DMA_ATTRS if PPC64
 	select USE_GENERIC_SMP_HELPERS if SMP
 	select HAVE_OPROFILE
+	select HAVE_SYSCALL_WRAPPERS if PPC64
 
 config EARLY_PRINTK
 	bool
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -103,8 +103,14 @@ struct old_linux_dirent;
 #define SYSCALL_DEFINE5(...)    SYSCALL_DEFINEx(5, __VA_ARGS__)
 #define SYSCALL_DEFINE6(...)    SYSCALL_DEFINEx(6, __VA_ARGS__)
 
+#ifdef CONFIG_PPC64
+#define SYSCALL_ALIAS(alias, name)					\
+	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name "\n"	\
+	     "\t.globl ." #alias "\n\t.set ." #alias ", ." #name)
+#else
 #define SYSCALL_ALIAS(alias, name)					\
 	asm ("\t.globl " #alias "\n\t.set " #alias ", " #name)
+#endif
 
 #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS
 

