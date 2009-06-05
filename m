Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZFEFmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZFEFmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 01:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbZFEFmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 01:42:11 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:56019 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777AbZFEFmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 01:42:09 -0400
Message-Id: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>
Subject: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: guillaume.thouvenin@ext.bull.net, avi@redhat.com
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 05 Jun 2009 14:39:58 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 05062009 #2087110, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Continued from http://lkml.org/lkml/2009/6/4/14 )
I tried to identify the location of gcc 3.3's internal error using
"make CONFIG_DEBUG_INFO=1 arch/x86/kvm/x86_emulate.s", and it turned out that
the location is emulate_2op_cl().

Commenting out like below solves the gcc's internal error.

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index ca91749..561b9b6 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -2070,7 +2070,7 @@ twobyte_insn:
                break;
        case 0xa4: /* shld imm8, r, r/m */
        case 0xa5: /* shld cl, r, r/m */
-               emulate_2op_cl("shld", c->src2, c->src, c->dst, ctxt->eflags);
+               //emulate_2op_cl("shld", c->src2, c->src, c->dst, ctxt->eflags);
                break;
        case 0xab:
              bts:              /* bts */
@@ -2080,7 +2080,7 @@ twobyte_insn:
                break;
        case 0xac: /* shrd imm8, r, r/m */
        case 0xad: /* shrd cl, r, r/m */
-               emulate_2op_cl("shrd", c->src2, c->src, c->dst, ctxt->eflags);
+               //emulate_2op_cl("shrd", c->src2, c->src, c->dst, ctxt->eflags);
                break;
        case 0xae:              /* clflush */
                break;

I think something is wrong with emulate_2op_cl() when compiled with gcc 3.3.5 .

Regards.
