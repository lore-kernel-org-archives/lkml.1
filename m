Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383Ab0BEGRH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:17:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15098 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932093Ab0BEGRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:17:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/2] kprobes: Add mcount in kprobes blacklist
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Date: Fri, 05 Feb 2010 01:24:34 -0500
Message-ID: <20100205062433.3745.36726.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100205062427.3745.85746.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100205062427.3745.85746.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since mcount function can be called from everywhere,
it should be blacklisted. Moreover, the "mcount" symbol
is a special symbol name. So, it is better to put it in
the generic blacklist.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 kernel/kprobes.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c3340e8..ccec774 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -94,6 +94,7 @@ static struct kprobe_blackpoint kprobe_blacklist[] = {
 	{"native_get_debugreg",},
 	{"irq_entries_start",},
 	{"common_interrupt",},
+	{"mcount",},	/* mcount can be called from everywhere */
 	{NULL}    /* Terminator */
 };
 


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
