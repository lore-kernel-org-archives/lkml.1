Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZJCCbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZJCCbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbZJCCbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:31:42 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:60874 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZJCCbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:31:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bMiNo0Cehq0/X40o3WCQ2MC03VMtkGeZoRdhBA2YBcksc2YNTGNLDsWCCmmywlGr/2
         zUYkW8RGYBgbmk3Vv7SJ7fwcrNbjOGuujfcBy2aX+FRFPB9gPofcJ2Tpz/YHjNQ6n8KN
         oOqtUksrFA5fBS1TSA1+3pFYR3MdgFB+D5gQ8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/3] x86: Add VIA processor instructions in opcodes decoder
Date: Sat,  3 Oct 2009 04:31:30 +0200
Message-Id: <1254537091-4993-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
References: <1254537091-4993-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

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
-- 
1.6.2.3

