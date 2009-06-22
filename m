Return-Path: <linux-kernel-owner+w=401wt.eu-S1758674AbZFVVAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758674AbZFVVAs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 17:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbZFVVA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 17:00:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58679 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758579AbZFVVA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 17:00:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [BUGFIX][ PATCH] kprobes: fix kprobe selftest configuration dependency
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 22 Jun 2009 17:03:02 -0400
Message-ID: <20090622210302.4984.82798.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Select CONFIG_KALLSYMS_ALL when CONFIG_KPROBES_SANITY_TEST=y.
Kprobe selftest always fail without CONFIG_KALLSYMS_ALL=y, because
kallsyms doesn't list up the target functions which are probed in this
test.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---

 lib/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 23067ab..661c675 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -727,6 +727,7 @@ config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	select KALLSYMS_ALL
 	default n
 	help
 	  This option provides for testing basic kprobes functionality on


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
