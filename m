Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbYGaAIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbYGaAIv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760133AbYGaAIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:08:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36199 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759432AbYGaAIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:08:18 -0400
Date: Wed, 30 Jul 2008 16:58:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mohammed Gamal <m.gamal005@gmail.com>,
       Avi Kivity <avi@qumranet.com>
Subject: [patch 12/62] KVM: x86 emulator: Fix HLT instruction
Message-ID: <20080730235812.GL12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="kvm-x86-emulator-fix-hlt-instruction.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: Mohammed Gamal <m.gamal005@gmail.com>

Original-Commit-Hash: bcc542267538e9ba933d08b4cd4ebd796e03a3d7

This patch fixes issue encountered with HLT instruction
under FreeDOS's HIMEM XMS Driver.

The HLT instruction jumped directly to the done label and
skips updating the EIP value, therefore causing the guest
to spin endlessly on the same instruction.

The patch changes the instruction so that it writes back
the updated EIP value.

Signed-off-by: Mohammed Gamal <m.gamal005@gmail.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1666,7 +1666,7 @@ special_insn:
 		break;
 	case 0xf4:              /* hlt */
 		ctxt->vcpu->arch.halt_request = 1;
-		goto done;
+		break;
 	case 0xf5:	/* cmc */
 		/* complement carry flag from eflags reg */
 		ctxt->eflags ^= EFLG_CF;

-- 
