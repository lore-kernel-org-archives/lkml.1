Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935106Ab0CMAZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:25:53 -0500
Received: from kroah.org ([198.145.64.141]:32889 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935066Ab0CMAVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:11 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:15 2010
Message-Id: <20100313001515.460754892@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [patch 118/123] KVM: x86 emulator: Add group9 instruction decoding
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Gleb Natapov <gleb@redhat.com>

commit 60a29d4ea4e7b6b95d9391ebc8625b0426f3a363 upstream.

Use groups mechanism to decode 0F C7 instructions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/emulate.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -88,7 +88,7 @@
 enum {
 	Group1_80, Group1_81, Group1_82, Group1_83,
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
-	Group8,
+	Group8, Group9,
 };
 
 static u32 opcode_table[256] = {
@@ -272,7 +272,8 @@ static u32 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov,
+	0, 0, 0, Group | GroupDual | Group9,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@@ -328,6 +329,8 @@ static u32 group_table[] = {
 	0, 0, 0, 0,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	[Group9*8] =
+	0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0,
 };
 
 static u32 group2_table[] = {
@@ -335,6 +338,8 @@ static u32 group2_table[] = {
 	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
+	[Group9*8] =
+	0, 0, 0, 0, 0, 0, 0, 0,
 };
 
 /* EFLAGS bit definitions. */


