Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbYB1N37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbYB1N37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYB1N3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:29:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbYB1N3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:29:50 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix hpet_(un)register_irq_handler() for emulation
To: torvalds@osdl.org, akpm@linux-foundation.org, bwalle@suse.de
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 28 Feb 2008 13:29:43 +0000
Message-ID: <20080228132943.7822.32718.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix hpet_(un)register_irq_handler() for when CONFIG_HPET_EMULATE_RTC=n.  They
are provided macros that substitute value 0, but if they are called as
functions and the return value isn't checked, the following warnings appear:

	drivers/char/rtc.c: In function `rtc_init':
	drivers/char/rtc.c:1063: warning: statement with no effect
	drivers/char/rtc.c: In function `rtc_exit':
	drivers/char/rtc.c:1157: warning: statement with no effect

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/rtc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 78b151c..5c3142b 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -110,8 +110,8 @@ static int rtc_has_irq = 1;
 #define hpet_set_rtc_irq_bit(arg)		0
 #define hpet_rtc_timer_init()			do { } while (0)
 #define hpet_rtc_dropped_irq()			0
-#define hpet_register_irq_handler(h)		0
-#define hpet_unregister_irq_handler(h)		0
+#define hpet_register_irq_handler(h)		({ 0; })
+#define hpet_unregister_irq_handler(h)		({ 0; })
 #ifdef RTC_IRQ
 static irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 {

