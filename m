Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZJXBGs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZJXBGs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 21:06:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753449AbZJXBGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 21:06:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:51747 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753266AbZJXBEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 21:04:52 -0400
Date: Sat, 24 Oct 2009 01:03:52 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, dle-develop@lists.sourceforge.net,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu, systemtap@sources.redhat.com
In-Reply-To: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:branch?] x86: Add AES opcodes to opcode map
Message-ID: <tip-9983d60d74db9e544c6cb6f65351849fe8e9c1de@git.kernel.org>
Git-Commit-ID: 9983d60d74db9e544c6cb6f65351849fe8e9c1de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9983d60d74db9e544c6cb6f65351849fe8e9c1de
Gitweb:     http://git.kernel.org/tip/9983d60d74db9e544c6cb6f65351849fe8e9c1de
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 20 Oct 2009 12:55:31 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Oct 2009 13:25:29 +0200

x86: Add AES opcodes to opcode map

Add Intel AES opcodes to x86 opcode map. These opcodes are
used in arch/x86/crypt/aesni-intel_asm.S.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap<systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091020165531.4145.21872.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
