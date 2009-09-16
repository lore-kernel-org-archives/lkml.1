Return-Path: <linux-kernel-owner+w=401wt.eu-S933603AbZIPWnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933603AbZIPWnm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760538AbZIPWne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:43:34 -0400
Received: from kroah.org ([198.145.64.141]:55416 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607AbZIPWkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:40:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:37:19 2009
Message-Id: <20090916223719.185046828@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:36:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Avi Kivity <avi@redhat.com>
Subject: [patch 40/45] KVM: x86 emulator: fix jmp far decoding (opcode 0xea)
References: <20090916223613.597295240@mini.kroah.org>
Content-Disposition: inline; filename=kvm-x86-emulator-fix-jmp-far-decoding.patch
In-Reply-To: <20090916223739.GA4789@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Avi Kivity <avi@redhat.com>

commit ee3d29e8bee8d7c321279a9bd9bd25d4cfbf79b7 upstream.

The jump target should not be sign extened; use an unsigned decode flag.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -196,7 +196,7 @@ static u32 opcode_table[256] = {
 	ByteOp | SrcImmUByte, SrcImmUByte,
 	/* 0xE8 - 0xEF */
 	SrcImm | Stack, SrcImm | ImplicitOps,
-	SrcImm | Src2Imm16, SrcImmByte | ImplicitOps,
+	SrcImmU | Src2Imm16, SrcImmByte | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	SrcNone | ByteOp | ImplicitOps, SrcNone | ImplicitOps,
 	/* 0xF0 - 0xF7 */


