Return-Path: <linux-kernel-owner+w=401wt.eu-S1752450AbZIYSTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbZIYSTU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 14:19:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZIYSTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 14:19:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352AbZIYSTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 14:19:16 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH tracing/kprobes 2/3] x86: Add VIA processor instructions
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Date: Fri, 25 Sep 2009 11:20:38 -0700
Message-ID: <20090925182037.10157.3180.stgit@omoto>
In-Reply-To: <20090925181952.10157.9975.stgit@omoto>
References: <20090925181952.10157.9975.stgit@omoto>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add VIA processor's Padlock instructions(MONTMUL, XSHA1, XSHA256).

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
