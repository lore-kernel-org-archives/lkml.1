Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbXLMHDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbXLMHDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 02:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761167AbXLMG40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:56:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55197 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760648AbXLMG4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:56:25 -0500
Date: Wed, 12 Dec 2007 22:51:55 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       kvm-devel@lists.sourceforge.net, Avi Kivity <avi@qumranet.com>
Subject: [patch 19/60] KVM: x86 emulator: invd instruction
Message-ID: <20071213065155.GT6867@kroah.com>
References: <20071213064518.328162328@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-x86-emulator-invd-instruction.patch"
In-Reply-To: <20071213065039.GA6867@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Avi Kivity <avi@qumranet.com>

patch 651a3e29b3d19418d7a8a9787906061f9be7cc5f in mainline.

Emulate the 'invd' instruction (opcode 0f 08).

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/kvm/x86_emulate.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -156,7 +156,7 @@ static u8 opcode_table[256] = {
 static u16 twobyte_table[256] = {
 	/* 0x00 - 0x0F */
 	0, SrcMem | ModRM | DstReg, 0, 0, 0, 0, ImplicitOps, 0,
-	0, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
+	ImplicitOps, ImplicitOps, 0, 0, 0, ImplicitOps | ModRM, 0, 0,
 	/* 0x10 - 0x1F */
 	0, 0, 0, 0, 0, 0, 0, 0, ImplicitOps | ModRM, 0, 0, 0, 0, 0, 0, 0,
 	/* 0x20 - 0x2F */
@@ -1353,6 +1353,8 @@ twobyte_special_insn:
 	/* Disable writeback. */
 	no_wb = 1;
 	switch (b) {
+	case 0x08:		/* invd */
+		break;
 	case 0x09:		/* wbinvd */
 		break;
 	case 0x0d:		/* GrpP (prefetch) */

-- 
