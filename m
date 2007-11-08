Return-Path: <linux-kernel-owner+w=401wt.eu-S1760535AbXKHCfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760535AbXKHCfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 21:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760230AbXKHCdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 21:33:41 -0500
Received: from gw.goop.org ([64.81.55.164]:57078 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760205AbXKHCdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 21:33:40 -0500
Message-Id: <20071108015008.660012621@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 07 Nov 2007 17:50:08 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Zach Amsden <zach@vmware.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>
Subject: [PATCH RFC 0/7] Unify asm-x86/pgtable.h and page.h
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NB: RFC ONLY.  DO NOT APPLY.

This series unifies many definitions in asm-x86/pgtable.h and page.h.
Later in the series, I take advantage of some of the earlier
infrastructure to simplify paravirt.h and bits of the Xen code.

This patch applies on top of Glauber's 64-bit pvops unification, so it
won't apply directly to the current tree.

I've tested all the 32-bit combinations
(paravirt/non-paravirt/PAE/non-PAE), but haven't set up a 64-bit test
box yet.

The diffstat of the pure unification bits is nice:
 arch/x86/mm/init_32.c            |   31 ++-
 arch/x86/mm/init_64.c            |    3 
 arch/x86/xen/enlighten.c         |    8 
 arch/x86/xen/mmu.c               |   67 +++-----
 arch/x86/xen/mmu.h               |   26 ---
 include/asm-x86/page.h           |   49 ++++-
 include/asm-x86/page_32.h        |   77 +++++----
 include/asm-x86/page_64.h        |   37 +---
 include/asm-x86/paravirt.h       |  324 ++++++++++++++++-----------------------
 include/asm-x86/pgtable-2level.h |   21 --
 include/asm-x86/pgtable-3level.h |   40 ----
 include/asm-x86/pgtable.h        |  318 ++++++++++++++++++++++++++++++++++++++
 include/asm-x86/pgtable_32.h     |  204 ------------------------
 include/asm-x86/pgtable_64.h     |  234 ----------------------------
 14 files changed, 630 insertions(+), 809 deletions(-)

(The code formatting patch adds a pile of lines because it splits long
single lints into multiline code.)

	J
-- 

