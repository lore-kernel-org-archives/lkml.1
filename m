Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXGTV1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXGTV1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 17:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760972AbXGTV1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 17:27:32 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:60544 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbXGTV1a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 17:27:30 -0400
Date: Fri, 20 Jul 2007 23:28:45 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4/7] x86_64: fix section mismatch warning in hpet.c
Message-ID: <20070720212845.GC25064@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following warnings:
WARNING: vmlinux.o(.text+0x945e): Section mismatch: reference to .init.text:__set_fixmap (between 'hpet_arch_init' and 'hpet_mask_rtc_irq_bit')
WARNING: vmlinux.o(.text+0x9474): Section mismatch: reference to .init.text:__set_fixmap (between 'hpet_arch_init' and 'hpet_mask_rtc_irq_bit')

hpet_arch_init is only used from __init context so mark it __init.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86_64/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86_64/kernel/hpet.c b/arch/x86_64/kernel/hpet.c
index b828696..3dc68d1 100644
--- a/arch/x86_64/kernel/hpet.c
+++ b/arch/x86_64/kernel/hpet.c
@@ -133,7 +133,7 @@ struct clocksource clocksource_hpet = {
 	.vread		= vread_hpet,
 };
 
-int hpet_arch_init(void)
+int __init hpet_arch_init(void)
 {
 	unsigned int id;
 	u64 tmp;
-- 
1.5.1.rc3.g84b7-dirty

