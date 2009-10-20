Return-Path: <linux-kernel-owner+w=401wt.eu-S1752723AbZJTQzR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbZJTQzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 12:55:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZJTQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 12:55:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2516 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbZJTQzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 12:55:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip perf/probes 2/2] x86: Add AES opcodes to opcode map
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Tue, 20 Oct 2009 12:55:31 -0400
Message-ID: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091020165518.4145.94115.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add Intel AES opcodes to x86 opcode map. These opcodes are
used in arch/x86/crypt/aesni-intel_asm.S.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/lib/x86-opcode-map.txt |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index 894497f..701c467 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -567,7 +567,7 @@ fe: paddd Pq,Qq | paddd Vdq,Wdq (66)
 ff:
 EndTable
 
-Table: 3-byte opcode 1
+Table: 3-byte opcode 1 (0x0f 0x38)
 Referrer: 3-byte escape 1
 # 0x0f 0x38 0x00-0x0f
 00: pshufb Pq,Qq | pshufb Vdq,Wdq (66)
@@ -642,11 +642,16 @@ Referrer: 3-byte escape 1
 41: phminposuw Vdq,Wdq (66)
 80: INVEPT Gd/q,Mdq (66)
 81: INVPID Gd/q,Mdq (66)
+db: aesimc Vdq,Wdq (66)
+dc: aesenc Vdq,Wdq (66)
+dd: aesenclast Vdq,Wdq (66)
+de: aesdec Vdq,Wdq (66)
+df: aesdeclast Vdq,Wdq (66)
 f0: MOVBE Gv,Mv | CRC32 Gd,Eb (F2)
 f1: MOVBE Mv,Gv | CRC32 Gd,Ev (F2)
 EndTable
 
-Table: 3-byte opcode 2
+Table: 3-byte opcode 2 (0x0f 0x3a)
 Referrer: 3-byte escape 2
 # 0x0f 0x3a 0x00-0xff
 08: roundps Vdq,Wdq,Ib (66)
@@ -671,6 +676,7 @@ Referrer: 3-byte escape 2
 61: pcmpestri Vdq,Wdq,Ib (66)
 62: pcmpistrm Vdq,Wdq,Ib (66)
 63: pcmpistri Vdq,Wdq,Ib (66)
+df: aeskeygenassist Vdq,Wdq,Ib (66)
 EndTable
 
 GrpTable: Grp1


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
