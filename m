Return-Path: <linux-kernel-owner+w=401wt.eu-S934288AbXGTSnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934288AbXGTSnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 14:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761607AbXGTSm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 14:42:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54288 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760832AbXGTSm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 14:42:56 -0400
Subject: [PATCH] i386: Mark pit_clockevent static
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: text/plain
Date: Fri, 20 Jul 2007 11:43:12 -0700
Message-Id: <1184956992.2630.14.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of arch/i386/kernel/i8253.c uses pit_clockevent, so mark it
static.

Eliminates a sparse warning:
warning: symbol 'pit_clockevent' was not declared. Should it be static?

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 arch/i386/kernel/i8253.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/i8253.c b/arch/i386/kernel/i8253.c
index f8a3c40..7ba1e76 100644
--- a/arch/i386/kernel/i8253.c
+++ b/arch/i386/kernel/i8253.c
@@ -91,7 +91,7 @@ static int pit_next_event(unsigned long delta, struct clock_event_device *evt)
  * registered. This mechanism replaces the previous #ifdef LOCAL_APIC -
  * !using_apic_timer decisions in do_timer_interrupt_hook()
  */
-struct clock_event_device pit_clockevent = {
+static struct clock_event_device pit_clockevent = {
 	.name		= "pit",
 	.features	= CLOCK_EVT_FEAT_PERIODIC | CLOCK_EVT_FEAT_ONESHOT,
 	.set_mode	= init_pit_timer,
-- 
1.5.2.1



