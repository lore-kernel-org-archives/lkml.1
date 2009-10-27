Return-Path: <linux-kernel-owner+w=401wt.eu-S932276AbZJ0Umv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbZJ0Umv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 16:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932198AbZJ0Umt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 16:42:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158AbZJ0Umr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 16:42:47 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 01/10] x86: Fix SSE opcode map bug
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
Date: Tue, 27 Oct 2009 16:42:04 -0400
Message-ID: <20091027204204.30545.97296.stgit@harusame>
In-Reply-To: <20091027204156.30545.96425.stgit@harusame>
References: <20091027204156.30545.96425.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix superscripts position because some superscripts of SSE opcode are
not put in correct position.

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

 arch/x86/lib/x86-opcode-map.txt |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 701c467..efef3ca 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -401,9 +401,9 @@ Referrer: 2-byte escape
 62: punpckldq Pq,Qd | punpckldq Vdq,Wdq (66)
 63: packsswb Pq,Qq | packsswb Vdq,Wdq (66)
 64: pcmpgtb Pq,Qq | pcmpgtb Vdq,Wdq (66)
-65: pcmpgtw Pq,Qq | pcmpgtw(66) Vdq,Wdq
+65: pcmpgtw Pq,Qq | pcmpgtw Vdq,Wdq (66)
 66: pcmpgtd Pq,Qq | pcmpgtd Vdq,Wdq (66)
-67: packuswb Pq,Qq | packuswb(66) Vdq,Wdq
+67: packuswb Pq,Qq | packuswb Vdq,Wdq (66)
 68: punpckhbw Pq,Qd | punpckhbw Vdq,Wdq (66)
 69: punpckhwd Pq,Qd | punpckhwd Vdq,Wdq (66)
 6a: punpckhdq Pq,Qd | punpckhdq Vdq,Wdq (66)
@@ -425,8 +425,8 @@ Referrer: 2-byte escape
 79: VMWRITE Gd/q,Ed/q
 7a:
 7b:
-7c: haddps(F2) Vps,Wps | haddpd(66) Vpd,Wpd
-7d: hsubps(F2) Vps,Wps | hsubpd(66) Vpd,Wpd
+7c: haddps Vps,Wps (F2) | haddpd Vpd,Wpd (66)
+7d: hsubps Vps,Wps (F2) | hsubpd Vpd,Wpd (66)
 7e: movd/q Ed/q,Pd | movd/q Ed/q,Vdq (66) | movq Vq,Wq (F3)
 7f: movq Qq,Pq | movdqa Wdq,Vdq (66) | movdqu Wdq,Vdq (F3)
 # 0x0f 0x80-0x8f
@@ -574,7 +574,7 @@ Referrer: 3-byte escape 1
 01: phaddw Pq,Qq | phaddw Vdq,Wdq (66)
 02: phaddd Pq,Qq | phaddd Vdq,Wdq (66)
 03: phaddsw Pq,Qq | phaddsw Vdq,Wdq (66)
-04: pmaddubsw Pq,Qq | pmaddubsw (66)Vdq,Wdq
+04: pmaddubsw Pq,Qq | pmaddubsw Vdq,Wdq (66)
 05: phsubw Pq,Qq | phsubw Vdq,Wdq (66)
 06: phsubd Pq,Qq | phsubd Vdq,Wdq (66)
 07: phsubsw Pq,Qq | phsubsw Vdq,Wdq (66)


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
