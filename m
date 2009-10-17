Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZJQKDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZJQKDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbZJQKDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:03:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:36564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZJQKDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:03:19 -0400
Date: Sat, 17 Oct 2009 10:02:39 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, ak@linux.intel.com, jbaron@redhat.com,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mhiramat@redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
       jkenisto@us.ibm.com, tzanussi@gmail.com, lizf@cn.fujitsu.com,
       hch@infradead.org, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
       mingo@elte.hu, prasad@linux.vnet.ibm.com
In-Reply-To: <20090925182037.10157.3180.stgit@omoto>
References: <20090925182037.10157.3180.stgit@omoto>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Add VIA processor instructions in opcodes decoder
Message-ID: <tip-c0b11d3af164947c71e2491912c5b8418900dafb@git.kernel.org>
Git-Commit-ID: c0b11d3af164947c71e2491912c5b8418900dafb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:02:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c0b11d3af164947c71e2491912c5b8418900dafb
Gitweb:     http://git.kernel.org/tip/c0b11d3af164947c71e2491912c5b8418900dafb
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 25 Sep 2009 11:20:38 -0700
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Sat, 3 Oct 2009 02:43:00 +0200

x86: Add VIA processor instructions in opcodes decoder

Add VIA processor's Padlock instructions(MONTMUL, XSHA1, XSHA256)
as parts of the kernel may use them.

This fixes the following crash in opcodes decoder selftests:

 make[2]: `scripts/unifdef' is up to date.
   TEST    posttest
 Error: c145cf71:        f3 0f a6 d0             repz xsha256
 Error: objdump says 4 bytes, but insn_get_length() says 3 (attr:0)
 make[1]: *** [posttest] Error 2
 make: *** [bzImage] Error 2

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20090925182037.10157.3180.stgit@omoto>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/lib/x86-opcode-map.txt |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 59e20d5..78a0daf 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -469,7 +469,7 @@ a2: CPUID
 a3: BT Ev,Gv
 a4: SHLD Ev,Gv,Ib
 a5: SHLD Ev,Gv,CL
-a6:
+a6: GrpPDLK
 a7: GrpRNG
 a8: PUSH GS (d64)
 a9: POP GS (d64)
@@ -803,6 +803,12 @@ GrpTable: Grp16
 3: prefetch T2
 EndTable
 
+GrpTable: GrpPDLK
+0: MONTMUL
+1: XSHA1
+2: XSHA2
+EndTable
+
 GrpTable: GrpRNG
 0: xstore-rng
 1: xcrypt-ecb
