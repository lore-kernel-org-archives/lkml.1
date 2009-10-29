Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZJ2IJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZJ2IJE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZJ2IJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:09:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:53022 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZJ2II6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:08:58 -0400
Date: Thu, 29 Oct 2009 08:08:03 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, hpa@zytor.com, fche@redhat.com,
       linux-kernel@vger.kernel.org, jkenisto@us.ibm.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, prasad@linux.vnet.ibm.com,
       mingo@elte.hu
In-Reply-To: <20091027204235.30545.33997.stgit@harusame>
References: <20091027204235.30545.33997.stgit@harusame>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Add Intel FMA instructions to x86 opcode map
Message-ID: <tip-3f7e454af1dd8b9cea410d9380d3f71477e94f2b@git.kernel.org>
Git-Commit-ID: 3f7e454af1dd8b9cea410d9380d3f71477e94f2b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3f7e454af1dd8b9cea410d9380d3f71477e94f2b
Gitweb:     http://git.kernel.org/tip/3f7e454af1dd8b9cea410d9380d3f71477e94f2b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 27 Oct 2009 16:42:35 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 29 Oct 2009 08:47:47 +0100

x86: Add Intel FMA instructions to x86 opcode map

Add Intel FMA(FUSED-MULTIPLY-ADD) instructions to x86 opcode map
for x86 instruction decoder.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jason Baron <jbaron@redhat.com>
Cc: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
LKML-Reference: <20091027204235.30545.33997.stgit@harusame>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
