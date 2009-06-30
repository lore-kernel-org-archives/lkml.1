Return-Path: <linux-kernel-owner+w=401wt.eu-S1752808AbZF3LmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808AbZF3LmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 07:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZF3Ll5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 07:41:57 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:45730 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZF3Ll4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 07:41:56 -0400
Message-Id: <4A4A16260200007800008340@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 30 Jun 2009 12:41:58 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <dhowells@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix hpet_(un)register_irq_handler() again for
	 emulation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 32fa458688fa2e68bc433929b2d4941eef7efe39 didn't really succeed
in what it was trying to do - depending on the compiler version, the
"statement with no effect" warnings still exist.

Since hpet_register_irq_handler() has its return value used, it can be
restored to expand to a plain 0 again.

For hpet_unregister_irq_handler(), an expression the effective of is
"void" ought to be used instead.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 drivers/char/rtc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.31-rc1/drivers/char/rtc.c	2009-03-24 00:12:14.000000000 +0100
+++ 2.6.31-rc1-rtc-warnings/drivers/char/rtc.c	2009-06-24 16:30:02.000000000 +0200
@@ -112,8 +112,8 @@ static int rtc_has_irq = 1;
 #define hpet_set_rtc_irq_bit(arg)		0
 #define hpet_rtc_timer_init()			do { } while (0)
 #define hpet_rtc_dropped_irq()			0
-#define hpet_register_irq_handler(h)		({ 0; })
-#define hpet_unregister_irq_handler(h)		({ 0; })
+#define hpet_register_irq_handler(h)		0
+#define hpet_unregister_irq_handler(h)		((void)0)
 #ifdef RTC_IRQ
 static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {



