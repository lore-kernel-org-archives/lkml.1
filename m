Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935833Ab0CMAhF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:37:05 -0500
Received: from kroah.org ([198.145.64.141]:47250 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935567Ab0CMAch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:37 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:17 2010
Message-Id: <20100313002717.250981719@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [138/145] KVM: x86 emulator: Add group8 instruction decoding
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Gleb Natapov <gleb@redhat.com>

commit 2db2c2eb6226e30f8059b82512a1364db98da8e3 upstream.

Use groups mechanism to decode 0F BA instructions.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/emulate.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -86,6 +86,7 @@
 enum {
 	Group1_80, Group1_81, Group1_82, Group1_83,
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
+	Group8,
 };
 
 static u32 opcode_table[256] = {
@@ -258,7 +259,7 @@ static u32 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xB8 - 0xBF */
-	0, 0, DstMem | SrcImmByte | ModRM, DstMem | SrcReg | ModRM | BitOp,
+	0, 0, Group | Group8, DstMem | SrcReg | ModRM | BitOp,
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
@@ -314,6 +315,10 @@ static u32 group_table[] = {
 	0, 0, ModRM | SrcMem, ModRM | SrcMem,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, SrcMem | ModRM | ByteOp,
+	[Group8*8] =
+	0, 0, 0, 0,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
 };
 
 static u32 group2_table[] = {


