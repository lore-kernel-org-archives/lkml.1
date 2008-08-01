Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbYHAVEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbYHAVEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758734AbYHAVD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:03:58 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:35192 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758885AbYHAVD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:03:57 -0400
Date: Fri, 1 Aug 2008 23:03:33 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Richard Purdie <rpurdie@rpsys.net>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds-wrap: Use default-on trigger for power led
Message-ID: <alpine.LNX.1.10.0808012259320.2294@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Fri, 01 Aug 2008 21:03:55 +0000
	Bayes: 0.1348 Tokens: new, 157; hammy, 2; neutral, 1; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1348]
X-Spam-Signature: 09332d063e7054b9789ea7e7803c7cc683f3f7d0
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The power led is normally lit after boot, let's use the default-on trigger as
the default trigger for it. This gets the initial brightness value right and
being on is the default behaviour we expect for a power led.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/leds-wrap.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

The patch is based on your current (024e8ac) leds git tree head.

diff --git a/drivers/leds/leds-wrap.c b/drivers/leds/leds-wrap.c
index 7ac61a7..2f3aa87 100644
--- a/drivers/leds/leds-wrap.c
+++ b/drivers/leds/leds-wrap.c
@@ -53,8 +53,9 @@ static void wrap_extra_led_set(struct led_classdev *led_cdev,
 }
 
 static struct led_classdev wrap_power_led = {
-	.name		= "wrap::power",
-	.brightness_set	= wrap_power_led_set,
+	.name			= "wrap::power",
+	.brightness_set		= wrap_power_led_set,
+	.default_trigger	= "default-on",
 };
 
 static struct led_classdev wrap_error_led = {
