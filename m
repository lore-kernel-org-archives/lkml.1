Return-Path: <linux-kernel-owner+w=401wt.eu-S1756888AbYE0OUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888AbYE0OUj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 10:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbYE0OUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 10:20:31 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:15125 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754878AbYE0OUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 10:20:31 -0400
Date: Tue, 27 May 2008 18:20:29 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: David Brownell <dbrownell@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] gpio: fix build errors for drivers not strictly requiring
	GPIOs
Message-ID: <20080527142029.GA31778@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since commit 7560fa60fcdcdb0da662f6a9fad9064b554ef46c (gpio: <linux/gpio.h>
and "no GPIO support here" stubs) drivers can use GPIOs if they're available,
but don't require them.

This patch actually enables this feature, otherwise drivers will stumble
against this:

include/asm-generic/gpio.h:111: error: redefinition of 'gpio_is_valid'
include/linux/gpio.h:21: error: previous definition of 'gpio_is_valid' was here
include/asm-generic/gpio.h:121: error: redefinition of 'gpio_cansleep'
include/linux/gpio.h:60: error: previous definition of 'gpio_cansleep' was here
include/asm-generic/gpio.h:126: error: redefinition of 'gpio_get_value_cansleep'
include/linux/gpio.h:67: error: previous definition of 'gpio_get_value_cansleep' was here
include/asm-generic/gpio.h:132: error: redefinition of 'gpio_set_value_cansleep'
include/linux/gpio.h:74: error: previous definition of 'gpio_set_value_cansleep' was here

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 include/asm-generic/gpio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
index 9c03b71..c9bcbd6 100644
--- a/include/asm-generic/gpio.h
+++ b/include/asm-generic/gpio.h
@@ -105,7 +105,7 @@ extern void __gpio_set_value(unsigned gpio, int value);
 extern int __gpio_cansleep(unsigned gpio);
 
 
-#else
+#elif defined(CONFIG_GENERIC_GPIO)
 
 static inline int gpio_is_valid(int number)
 {
-- 
1.5.5.1
