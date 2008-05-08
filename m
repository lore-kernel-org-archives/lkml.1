Return-Path: <linux-kernel-owner+w=401wt.eu-S932913AbYEHRsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932913AbYEHRsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbYEHRnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:43:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763380AbYEHRnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:43:40 -0400
Date: Thu, 8 May 2008 10:42:19 -0700
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
       Lennert Buytenhek <buytenh@marvell.com>,
       Nicolas Pitre <nico@marvell.com>
Subject: [patch 10/16] kprobes/arm: fix decoding of arithmetic immediate
	instructions
Message-ID: <20080508174219.GK855@suse.de>
References: <20080508173436.454278564@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kprobes-arm-fix-decoding-of-arithmetic-immediate-instructions.patch"
In-Reply-To: <20080508174122.GA855@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Lennert Buytenhek <buytenh@wantstofly.org>

The ARM kprobes arithmetic immediate instruction decoder
(space_cccc_001x()) was accidentally zero'ing out not only the Rn and
Rd arguments, but the lower nibble of the immediate argument as well
-- this patch fixes this.

Mainline commit: a3fd133c24e16d430ba21f3d9f5c0b8faeeb37fe

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
Acked-by: Nicolas Pitre <nico@marvell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/arm/kernel/kprobes-decode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/kernel/kprobes-decode.c
+++ b/arch/arm/kernel/kprobes-decode.c
@@ -1176,7 +1176,7 @@ space_cccc_001x(kprobe_opcode_t insn, st
 	 * *S (bit 20) updates condition codes
 	 * ADC/SBC/RSC reads the C flag
 	 */
-	insn &= 0xfff00ff0;	/* Rn = r0, Rd = r0 */
+	insn &= 0xfff00fff;	/* Rn = r0, Rd = r0 */
 	asi->insn[0] = insn;
 	asi->insn_handler = (insn & (1 << 20)) ?  /* S-bit */
 			emulate_alu_imm_rwflags : emulate_alu_imm_rflags;

-- 
