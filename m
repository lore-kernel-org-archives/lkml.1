Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZBKVeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZBKVeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753400AbZBKVeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:34:06 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57182 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbZBKVeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:34:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] PM: Fix build for CONFIG_PM unset
Date: Wed, 11 Feb 2009 22:33:20 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc4-tst; KDE/4.2.0; x86_64; ; )
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Cheng Renquan <crquan@gmail.com>
References: <200901062112.29227.rjw@sisk.pl> <49922896.6090605@redhat.com> <200902111038.46368.rjw@sisk.pl>
In-Reply-To: <200902111038.46368.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902112233.21529.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Compilation of kprobes.c with CONFIG_PM unset is broken due to some
broken config dependncies.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Ingo Molnar <mingo@elte.hu>
Tested-by: Masami Hiramatsu <mhiramat@redhat.com>
---
 kernel/Makefile       |    1 +
 kernel/power/Makefile |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile
+++ linux-2.6/kernel/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_PM) += power/
+obj-$(CONFIG_FREEZER) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile
+++ linux-2.6/kernel/power/Makefile
@@ -3,7 +3,7 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
-obj-y				:= main.o
+obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
