Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0CJTnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 14:43:37 -0500
Received: from xenotime.net ([72.52.64.118]:46968 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751183Ab0CJTng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 14:43:36 -0500
Message-ID: <4B97F666.9020709@xenotime.net>
Date: Wed, 10 Mar 2010 11:43:34 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org,
       Bjarke Istrup Pedersen <gurligebis@gentoo.org>
Subject: [PATCH -mmotm] leds: fix net5501 kconfig
References: <201003100342.o2A3gKvA022440@imap1.linux-foundation.org>
In-Reply-To: <201003100342.o2A3gKvA022440@imap1.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

LEDS_NET5501 selects LEDS_TRIGGER_DEFAULT_ON even when the symbol
LEDS_TRIGGERS is not enabled.  This causes build errors, so make
LEDS_NET5501 depend on LEDS_TRIGGERS to prevent the build errors.

drivers/leds/ledtrig-default-on.c:25: error: variable 'defon_led_trigger' has initializer but incomplete type
drivers/leds/ledtrig-default-on.c:26: error: unknown field 'name' specified in initializer
drivers/leds/ledtrig-default-on.c:26: warning: excess elements in struct initializer
drivers/leds/ledtrig-default-on.c:26: warning: (near initialization for 'defon_led_trigger')
drivers/leds/ledtrig-default-on.c:27: error: unknown field 'activate' specified in initializer
drivers/leds/ledtrig-default-on.c:27: warning: excess elements in struct initializer
drivers/leds/ledtrig-default-on.c:27: warning: (near initialization for 'defon_led_trigger')
drivers/leds/ledtrig-default-on.c:32: error: implicit declaration of function 'led_trigger_register'
drivers/leds/ledtrig-default-on.c:37: error: implicit declaration of function 'led_trigger_unregister'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
---
 drivers/leds/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- mmotm-2010-0309-1915.orig/drivers/leds/Kconfig
+++ mmotm-2010-0309-1915/drivers/leds/Kconfig
@@ -69,7 +69,8 @@ config LEDS_NET48XX
 
 config LEDS_NET5501
 	tristate "LED Support for Soekris net5501 series Error LED"
-	depends on LEDS_CLASS && LEDS_GPIO_PLATFORM && GPIO_CS5535
+	depends on LEDS_CLASS && LEDS_TRIGGERS
+	depends on LEDS_GPIO_PLATFORM && GPIO_CS5535
 	select LEDS_TRIGGER_DEFAULT_ON
 	default n
 	help
