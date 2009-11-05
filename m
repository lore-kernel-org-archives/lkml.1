Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZKEHuO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZKEHuO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 02:50:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZKEHuN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 02:50:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44192 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750787AbZKEHuM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 02:50:12 -0500
Date: Thu, 5 Nov 2009 18:50:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kristoffer Glembo <kristoffer@gaisler.com>
Subject: linux-next: sparc tree build failure
Message-Id: <20091105185014.76dd0d31.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/serial/apbuart.c:32:23: error: asm/oplib.h: No such file or directory
drivers/serial/apbuart.c:586: error: variable 'grlib_apbuart_of_driver' has initializer but incomplete type
drivers/serial/apbuart.c:587: error: unknown field 'match_table' specified in initializer
drivers/serial/apbuart.c:587: warning: excess elements in struct initializer
drivers/serial/apbuart.c:587: warning: (near initialization for 'grlib_apbuart_of_driver')
drivers/serial/apbuart.c:588: error: unknown field 'probe' specified in initializer
drivers/serial/apbuart.c:588: warning: excess elements in struct initializer
drivers/serial/apbuart.c:588: warning: (near initialization for 'grlib_apbuart_of_driver')
drivers/serial/apbuart.c:589: error: unknown field 'driver' specified in initializer
drivers/serial/apbuart.c:589: error: extra brace group at end of initializer
drivers/serial/apbuart.c:589: error: (near initialization for 'grlib_apbuart_of_driver')
drivers/serial/apbuart.c:592: warning: excess elements in struct initializer
drivers/serial/apbuart.c:592: warning: (near initialization for 'grlib_apbuart_of_driver')
drivers/serial/apbuart.c: In function 'grlib_apbuart_configure':
drivers/serial/apbuart.c:613: error: implicit declaration of function 'prom_getchild'
drivers/serial/apbuart.c:613: error: 'prom_root_node' undeclared (first use in this function)
drivers/serial/apbuart.c:613: error: (Each undeclared identifier is reported only once
drivers/serial/apbuart.c:613: error: for each function it appears in.)
drivers/serial/apbuart.c:614: error: implicit declaration of function 'prom_getint'
drivers/serial/apbuart.c: In function 'grlib_apbuart_init':
drivers/serial/apbuart.c:679: error: implicit declaration of function 'of_register_driver'
drivers/serial/apbuart.c:679: error: 'of_platform_bus_type' undeclared (first use in this function)

Caused by commit d4ac42a582e46d7f86f0acb4253a310423c72c4c ("sparc:
Support for GRLIB APBUART serial port").  I added the following patch for
today.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 5 Nov 2009 18:40:55 +1100
Subject: [PATCH] sparc: the GRLIB APBUART serial port will only build on sparc

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/serial/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 50943ff..7ec806d 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -1480,6 +1480,7 @@ config SERIAL_BCM63XX_CONSOLE
 config SERIAL_GRLIB_GAISLER_APBUART
 	tristate "GRLIB APBUART serial support"
 	depends on OF
+	depends on SPARC
 	---help---
 	Add support for the GRLIB APBUART serial port.
 
-- 
1.6.5.2


-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/
