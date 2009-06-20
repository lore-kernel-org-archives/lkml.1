Return-Path: <linux-kernel-owner+w=401wt.eu-S1754476AbZFTHtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754476AbZFTHtS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751664AbZFTHtC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:49:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:49706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbZFTHtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:49:01 -0400
Subject: [KVM] x86: kvm/x86_emulate.c toggle_interruptibility() should be
 static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       KVM list <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1245324205.7189.6.camel@localhost.localdomain>
References: <1245324205.7189.6.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 13:18:16 +0530
Message-Id: <1245484096.3102.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


toggle_interruptibility() is used only by same file, it should be static.

Fixed following sparse warning :

  arch/x86/kvm/x86_emulate.c:1364:6: warning: symbol 'toggle_interruptibility' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index c1b6c23..616de46 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -1361,7 +1361,7 @@ static inline int writeback(struct x86_emulate_ctxt *ctxt,
 	return 0;
 }
 
-void toggle_interruptibility(struct x86_emulate_ctxt *ctxt, u32 mask)
+static void toggle_interruptibility(struct x86_emulate_ctxt *ctxt, u32 mask)
 {
 	u32 int_shadow = kvm_x86_ops->get_interrupt_shadow(ctxt->vcpu, mask);
 	/*
-- 
1.6.0.6



