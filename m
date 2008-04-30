Return-Path: <linux-kernel-owner+w=401wt.eu-S1761611AbYD3Sym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761611AbYD3Sym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYD3Syc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:54:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48412 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756840AbYD3Syb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:54:31 -0400
Date: Wed, 30 Apr 2008 20:54:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Torokhov <dtor@mail.ru>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [patch, -git] input: CONFIG_INPUT_APANEL build fix
Message-ID: <20080430185345.GA27224@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


x86.git testing found this build failure in upstream -git:

 drivers/built-in.o: In function `apanel_detach_client':
 apanel.c:(.text+0x3027af): undefined reference to `led_classdev_unregister'
 drivers/built-in.o: In function `apanel_probe':
 apanel.c:(.text+0x302ac9): undefined reference to `led_classdev_register'

with this config:

 http://redhat.com/~mingo/misc/config-Wed_Apr_30_20_22_20_CEST_2008.bad

this driver has a missing CONFIG_NEW_LEDS dependency.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/input/misc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/input/misc/Kconfig
===================================================================
--- linux.orig/drivers/input/misc/Kconfig
+++ linux/drivers/input/misc/Kconfig
@@ -43,7 +43,7 @@ config INPUT_M68K_BEEP
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86 && I2C && LEDS_CLASS
+	depends on X86 && I2C && LEDS_CLASS && NEW_LEDS
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
 	help
