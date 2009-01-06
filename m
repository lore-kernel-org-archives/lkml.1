Return-Path: <linux-kernel-owner+w=401wt.eu-S1754173AbZAFURF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173AbZAFURF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 15:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753488AbZAFUQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 15:16:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37719 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZAFUQ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 15:16:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 1/2] PM: Fix freezer compilation if PM_SLEEP is unset
Date: Tue, 6 Jan 2009 21:14:04 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Masami Hiramatsu <mhiramat@redhat.com>,
       Cheng Renquan <crquan@gmail.com>
References: <200901062112.29227.rjw@sisk.pl>
In-Reply-To: <200901062112.29227.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901062114.04649.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Freezer fails to compile if with the following configuration
settings:

CONFIG_CGROUPS=y
CONFIG_CGROUP_FREEZER=y
CONFIG_MODULES=y
CONFIG_FREEZER=y
CONFIG_PM=y
CONFIG_PM_SLEEP=n

Fix this by making process.o compilation depend on CONFIG_FREEZER.

Reported-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@suse.cz>
---
 kernel/power/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile
+++ linux-2.6/kernel/power/Makefile
@@ -4,7 +4,8 @@ EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
 obj-y				:= main.o
-obj-$(CONFIG_PM_SLEEP)		+= process.o console.o
+obj-$(CONFIG_PM_SLEEP)		+= console.o
+obj-$(CONFIG_FREEZER)		+= process.o
 obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o


