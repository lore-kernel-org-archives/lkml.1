Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab0BBVlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:41:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756614Ab0BBVlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:41:39 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 0/4] kprobes updates
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Date: Tue, 02 Feb 2010 16:48:56 -0500
Message-ID: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are patches for updating kprobes. Actually, the first patch is
same as that previously I sent to LKML. 2nd-4th patches introduces text
reserve functions for avoiding conflictions between alternatives/
ftrace and kprobes. Since alternatives and ftrace can modify fixed
small pieces of kernel text, I think those should come before kprobes.

Thank you,

---

Masami Hiramatsu (4):
      ftrace: Remove record freezing
      kprobes: Check probe address is reserved
      ftrace/alternatives: Introducing *_text_reserved functions
      [RESEND] kprobes: Disable booster when CONFIG_PREEMPT=y


 arch/ia64/kernel/kprobes.c         |    2 +
 arch/x86/include/asm/alternative.h |    5 +++
 arch/x86/kernel/alternative.c      |   16 +++++++++++
 arch/x86/kernel/kprobes.c          |    5 +++
 include/linux/ftrace.h             |    7 ++++-
 kernel/kprobes.c                   |   33 +++-------------------
 kernel/trace/ftrace.c              |   54 ++++++++++--------------------------
 7 files changed, 52 insertions(+), 70 deletions(-)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division
e-mail: mhiramat@redhat.com
