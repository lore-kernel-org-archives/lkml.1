Return-Path: <linux-kernel-owner+w=401wt.eu-S932306AbZJ0UnP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306AbZJ0UnP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:43:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932281AbZJ0UnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:43:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199AbZJ0UnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:43:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 05/10] x86: Add Intel FMA instructions to x86
	opcode map
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jason Baron <jbaron@redhat.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 16:42:35 -0400
Message-ID: <20091027204235.30545.33997.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel FMA(FUSED-MULTIPLY-ADD) instructions to x86 opcode map
for x86 instruction decoder.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

 arch/x86/lib/x86-opcode-map.txt |   34 +++++++++++++++++++++++++++++++++-
 1 files changed, 33 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 9887bfe..a793da5 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -647,11 +647,43 @@ AVXcode: 2
 3d: pmaxsd Vdq,Wdq (66),(VEX),(o128)
 3e: pmaxuw Vdq,Wdq (66),(VEX),(o128)
 3f: pmaxud Vdq,Wdq (66),(VEX),(o128)
-# 0x0f 0x38 0x4f-0xff
+# 0x0f 0x38 0x40-0x8f
 40: pmulld Vdq,Wdq (66),(VEX),(o128)
 41: phminposuw Vdq,Wdq (66),(VEX),(o128)
 80: INVEPT Gd/q,Mdq (66)
 81: INVPID Gd/q,Mdq (66)
+# 0x0f 0x38 0x90-0xbf (FMA)
+96: vfmaddsub132pd/ps /r (66),(VEX)
+97: vfmsubadd132pd/ps /r (66),(VEX)
+98: vfmadd132pd/ps /r (66),(VEX)
+99: vfmadd132sd/ss /r (66),(VEX),(o128)
+9a: vfmsub132pd/ps /r (66),(VEX)
+9b: vfmsub132sd/ss /r (66),(VEX),(o128)
+9c: vfnmadd132pd/ps /r (66),(VEX)
+9d: vfnmadd132sd/ss /r (66),(VEX),(o128)
+9e: vfnmsub132pd/ps /r (66),(VEX)
+9f: vfnmsub132sd/ss /r (66),(VEX),(o128)
+a6: vfmaddsub213pd/ps /r (66),(VEX)
+a7: vfmsubadd213pd/ps /r (66),(VEX)
+a8: vfmadd213pd/ps /r (66),(VEX)
+a9: vfmadd213sd/ss /r (66),(VEX),(o128)
+aa: vfmsub213pd/ps /r (66),(VEX)
+ab: vfmsub213sd/ss /r (66),(VEX),(o128)
+ac: vfnmadd213pd/ps /r (66),(VEX)
+ad: vfnmadd213sd/ss /r (66),(VEX),(o128)
+ae: vfnmsub213pd/ps /r (66),(VEX)
+af: vfnmsub213sd/ss /r (66),(VEX),(o128)
+b6: vfmaddsub231pd/ps /r (66),(VEX)
+b7: vfmsubadd231pd/ps /r (66),(VEX)
+b8: vfmadd231pd/ps /r (66),(VEX)
+b9: vfmadd231sd/ss /r (66),(VEX),(o128)
+ba: vfmsub231pd/ps /r (66),(VEX)
+bb: vfmsub231sd/ss /r (66),(VEX),(o128)
+bc: vfnmadd231pd/ps /r (66),(VEX)
+bd: vfnmadd231sd/ss /r (66),(VEX),(o128)
+be: vfnmsub231pd/ps /r (66),(VEX)
+bf: vfnmsub231sd/ss /r (66),(VEX),(o128)
+# 0x0f 0x38 0xc0-0xff
 db: aesimc Vdq,Wdq (66),(VEX),(o128)
 dc: aesenc Vdq,Wdq (66),(VEX),(o128)
 dd: aesenclast Vdq,Wdq (66),(VEX),(o128)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
