Return-Path: <linux-kernel-owner+w=401wt.eu-S1758232AbZF3VGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758232AbZF3VGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbZF3VFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:05:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38797 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757612AbZF3VF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:05:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 1/3] kprobes: fix kprobe selftest configuration dependency
To: Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>
Date: Tue, 30 Jun 2009 17:08:03 -0400
Message-ID: <20090630210803.17851.73200.stgit@localhost.localdomain>
In-Reply-To: <20090630210757.17851.409.stgit@localhost.localdomain>
References: <20090630210757.17851.409.stgit@localhost.localdomain>
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
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
---

 lib/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 80d6db7..741a860 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -740,6 +740,7 @@ config KPROBES_SANITY_TEST
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
