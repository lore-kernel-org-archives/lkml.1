Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935626Ab0CMAne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:43:34 -0500
Received: from kroah.org ([198.145.64.141]:47257 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935572Ab0CMAci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:32:38 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:17 2010
Message-Id: <20100313002717.420595290@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:27:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>
Subject: [140/145] KVM: x86 emulator: Add group9 instruction decoding
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
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
@@ -86,7 +86,7 @@
 enum {
 	Group1_80, Group1_81, Group1_82, Group1_83,
 	Group1A, Group3_Byte, Group3, Group4, Group5, Group7,
-	Group8,
+	Group8, Group9,
 };
 
 static u32 opcode_table[256] = {
@@ -263,7 +263,8 @@ static u32 twobyte_table[256] = {
 	0, 0, ByteOp | DstReg | SrcMem | ModRM | Mov,
 	    DstReg | SrcMem16 | ModRM | Mov,
 	/* 0xC0 - 0xCF */
-	0, 0, 0, DstMem | SrcReg | ModRM | Mov, 0, 0, 0, ImplicitOps | ModRM,
+	0, 0, 0, DstMem | SrcReg | ModRM | Mov,
+	0, 0, 0, Group | GroupDual | Group9,
 	0, 0, 0, 0, 0, 0, 0, 0,
 	/* 0xD0 - 0xDF */
 	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
@@ -319,6 +320,8 @@ static u32 group_table[] = {
 	0, 0, 0, 0,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
 	DstMem | SrcImmByte | ModRM, DstMem | SrcImmByte | ModRM,
+	[Group9*8] =
+	0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0,
 };
 
 static u32 group2_table[] = {
@@ -326,6 +329,8 @@ static u32 group2_table[] = {
 	SrcNone | ModRM, 0, 0, SrcNone | ModRM,
 	SrcNone | ModRM | DstMem | Mov, 0,
 	SrcMem16 | ModRM | Mov, 0,
+	[Group9*8] =
+	0, 0, 0, 0, 0, 0, 0, 0,
 };
 
 /* EFLAGS bit definitions. */


