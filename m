Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbYL2Qnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbYL2Qnp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751580AbYL2Qnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:43:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:35741 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYL2Qng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:43:36 -0500
Subject: x86: genx2apic_phys.c x2apic_send_IPI_self and init_x2apic_ldr
	should be static
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 22:11:40 +0530
Message-Id: <1230568900.26564.18.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, reduce kernel size a bit, avoid sparse warnings

Fixes sparse warnings:
arch/x86/kernel/genx2apic_phys.c:164:6: warning: symbol 'x2apic_send_IPI_self' was not declared. Should it be static?
arch/x86/kernel/genx2apic_phys.c:169:6: warning: symbol 'init_x2apic_ldr' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/genx2apic_phys.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_phys.c b/arch/x86/kernel/genx2apic_phys.c
index 62895cf..21bcc0e 100644
--- a/arch/x86/kernel/genx2apic_phys.c
+++ b/arch/x86/kernel/genx2apic_phys.c
@@ -161,12 +161,12 @@ static unsigned int phys_pkg_id(int index_msb)
 	return current_cpu_data.initial_apicid >> index_msb;
 }
 
-void x2apic_send_IPI_self(int vector)
+static void x2apic_send_IPI_self(int vector)
 {
 	apic_write(APIC_SELF_IPI, vector);
 }
 
-void init_x2apic_ldr(void)
+static void init_x2apic_ldr(void)
 {
 	return;
 }
-- 
1.5.5.1



