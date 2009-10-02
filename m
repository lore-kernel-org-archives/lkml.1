Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZJBS2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZJBS2S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZJBS2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:28:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:44856 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755048AbZJBS2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:28:16 -0400
Date: Fri, 2 Oct 2009 18:27:59 GMT
From: tip-bot for Matteo Croce <technoboy85@gmail.com>
Cc: linux-kernel@vger.kernel.org, technoboy85@gmail.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, technoboy85@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <40101cc30910010811v5d15ff4cx9dd57c9cc9b4b045@mail.gmail.com>
References: <40101cc30910010811v5d15ff4cx9dd57c9cc9b4b045@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86: AMD Geode LX optimizations
Message-ID: <tip-98059e3463383b18fd79181179cd539b74846b47@git.kernel.org>
Git-Commit-ID: 98059e3463383b18fd79181179cd539b74846b47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 02 Oct 2009 18:28:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98059e3463383b18fd79181179cd539b74846b47
Gitweb:     http://git.kernel.org/tip/98059e3463383b18fd79181179cd539b74846b47
Author:     Matteo Croce <technoboy85@gmail.com>
AuthorDate: Thu, 1 Oct 2009 17:11:10 +0200
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 2 Oct 2009 11:24:28 -0700

x86: AMD Geode LX optimizations

Add CPU optimizations for AMD Geode LX.

Signed-off-by: Matteo Croce <technoboy85@gmail.com>
LKML-Reference: <40101cc30910010811v5d15ff4cx9dd57c9cc9b4b045@mail.gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/Kconfig.cpu     |    2 +-
 arch/x86/Makefile_32.cpu |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 527519b..979de29 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -406,7 +406,7 @@ config X86_CMPXCHG64
 # generates cmov.
 config X86_CMOV
 	def_bool y
-	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM)
+	depends on (MK8 || MK7 || MCORE2 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MVIAC3_2 || MVIAC7 || MCRUSOE || MEFFICEON || X86_64 || MATOM || MGEODE_LX)
 
 config X86_MINIMUM_CPU_FAMILY
 	int
diff --git a/arch/x86/Makefile_32.cpu b/arch/x86/Makefile_32.cpu
index 30e9a26..cbf0776 100644
--- a/arch/x86/Makefile_32.cpu
+++ b/arch/x86/Makefile_32.cpu
@@ -41,7 +41,7 @@ cflags-$(CONFIG_X86_ELAN)	+= -march=i486
 
 # Geode GX1 support
 cflags-$(CONFIG_MGEODEGX1)	+= -march=pentium-mmx
-
+cflags-$(CONFIG_MGEODE_LX)	+= $(call cc-option,-march=geode,-march=pentium-mmx)
 # add at the end to overwrite eventual tuning options from earlier
 # cpu entries
 cflags-$(CONFIG_X86_GENERIC) 	+= $(call tune,generic,$(call tune,i686))
