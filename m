Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZJ2QP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZJ2QP2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbZJ2QP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:15:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815AbZJ2QP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:15:26 -0400
Date: Thu, 29 Oct 2009 09:14:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Please pull powerpc.git merge branch
In-Reply-To: <1256627452.11607.90.camel@pasglop>
Message-ID: <alpine.LFD.2.01.0910290911550.31845@localhost.localdomain>
References: <1256627452.11607.90.camel@pasglop>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Oct 2009, Benjamin Herrenschmidt wrote:
> 
> Kumar Gala (7):
>       powerpc: Add a Book-3E 64-bit defconfig
>       powerpc: Fix compile errors found by new ppc64e_defconfig
>       powerpc: Limit hugetlbfs support to PPC64 Book-3S machines

This is incredibly ugly. Why should the generic fs/Kconfig know about some 
random odd architecture detail like PPC_BOOK3S_64?

I merged it, and noticed this because Super-H caused clashes by cleaning 
up. I would suggest PowerPC do the same.

This patch is not signed-off, nor do I want any credit. But if it works on 
ppc, please send me something like this back.

		Linus
---
 arch/powerpc/Kconfig |    3 +++
 fs/Kconfig           |    2 +-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 10a0a54..877db84 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -131,6 +131,9 @@ config PPC
 	select GENERIC_ATOMIC64 if PPC32
 	select HAVE_PERF_EVENTS
 
+config SYS_SUPPORTS_HUGETLBFS
+	defbool PPC_BOOK3S_64
+
 config EARLY_PRINTK
 	bool
 	default y
diff --git a/fs/Kconfig b/fs/Kconfig
index 2126078..64d44ef 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -135,7 +135,7 @@ config TMPFS_POSIX_ACL
 
 config HUGETLBFS
 	bool "HugeTLB file system support"
-	depends on X86 || IA64 || PPC_BOOK3S_64 || SPARC64 || (S390 && 64BIT) || \
+	depends on X86 || IA64 || SPARC64 || (S390 && 64BIT) || \
 		   SYS_SUPPORTS_HUGETLBFS || BROKEN
 	help
 	  hugetlbfs is a filesystem backing for HugeTLB pages, based on
