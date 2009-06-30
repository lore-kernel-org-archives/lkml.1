Return-Path: <linux-kernel-owner+w=401wt.eu-S1758288AbZF3Vkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758288AbZF3Vkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbZF3Vkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:40:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:58960 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020AbZF3Vkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:40:37 -0400
Date: Tue, 30 Jun 2009 21:39:53 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, ananth@in.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, ananth@in.ibm.com, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20090630210803.17851.73200.stgit@localhost.localdomain>
References: <20090630210803.17851.73200.stgit@localhost.localdomain>
Subject: [tip:tracing/urgent] kprobes: Fix kprobe selftest configuration dependency
Message-ID: <tip-130c5b2a0f78ba37f60f58010960fca29beaaf2d@git.kernel.org>
Git-Commit-ID: 130c5b2a0f78ba37f60f58010960fca29beaaf2d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 30 Jun 2009 21:39:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  130c5b2a0f78ba37f60f58010960fca29beaaf2d
Gitweb:     http://git.kernel.org/tip/130c5b2a0f78ba37f60f58010960fca29beaaf2d
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 30 Jun 2009 17:08:03 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 30 Jun 2009 23:21:55 +0200

kprobes: Fix kprobe selftest configuration dependency

Select CONFIG_KALLSYMS_ALL when CONFIG_KPROBES_SANITY_TEST=y.
Kprobe selftest always fail without CONFIG_KALLSYMS_ALL=y,
because kallsyms doesn't list up the target functions which are
probed in this test.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap<systemtap@sources.redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20090630210803.17851.73200.stgit@localhost.localdomain>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4c32b1a..876407b 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -728,6 +728,7 @@ config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	select KALLSYMS_ALL
 	default n
 	help
 	  This option provides for testing basic kprobes functionality on
