Return-Path: <linux-kernel-owner+w=401wt.eu-S1761791AbYBLULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761791AbYBLULE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 15:11:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762977AbYBLUKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 15:10:34 -0500
Received: from wr-out-0506.google.com ([64.233.184.229]:52442 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761912AbYBLUKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 15:10:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pJn7f+6XIjZAAVWJ5Pm16WD/TWkKhJZ6WshHqMUH08X8GZka43B3+wU9jI3S0TnnYByluOUH/w1b/XoMRftym2U7DI73GleDPfcs0iuiaEq9D9+RXTAaQR1dq67baEU3Ln3EnqNxNhaZbZuUm5+M2dXakw7M5fGQIrqFfv6ZMPQ=
Subject: [PATCH] x86: pit_clockevent can be static
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 12:10:27 -0800
Message-Id: <1202847027.28953.4.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/i8253.c:98:27: warning: symbol 'pit_clockevent' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/i8253.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/i8253.c b/arch/x86/kernel/i8253.c
index ef62b07..8540abe 100644
--- a/arch/x86/kernel/i8253.c
+++ b/arch/x86/kernel/i8253.c
@@ -95,7 +95,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
-struct clock_event_device pit_clockevent = {
+static struct clock_event_device pit_clockevent = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
-- 
1.5.4.1.1278.gc75be


