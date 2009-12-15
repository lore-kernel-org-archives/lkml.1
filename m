Return-Path: <linux-kernel-owner+w=401wt.eu-S1751176AbZLOFWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbZLOFWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 00:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750954AbZLOFWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 00:22:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:33320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750932AbZLOFWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 00:22:07 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18FJXJdoTwFqVxh+czTogYb1PPAxWlnIhM/Ms2hox
	0clwEDbaH6qzhI
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: devel@driverdev.osuosl.org, Willy Tarreau <w@1wt.eu>,
       Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
       Costantino Leandro <lcostantino@gmail.com>,
       linux-kernel@vger.kernel.org, Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH] Fix compilation error of drivers/staging/panel/panel.c w/ custom lcd charset
Date: Tue, 15 Dec 2009 06:21:45 +0100
Message-Id: <1260854505-17786-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling panel.c with a DEFAULT_LCD_CHARSET it fails to compile
with the following error message:
drivers/staging/panel/panel.c: In function >>lcd_init<<:
drivers/staging/panel/panel.c:1396: error: expected expression before
>>;<< token
drivers/staging/panel/panel.c:1475: error: expected expression before
>>;<< token
make[3]: *** [drivers/staging/panel/panel.o] error 1
make[2]: *** [drivers/staging/panel] error 2
make[1]: *** [drivers/staging] error 2

The config used was:
CONFIG_PANEL=m
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=0
CONFIG_PANEL_KEYPAD=0
CONFIG_PANEL_LCD=1
CONFIG_PANEL_LCD_HEIGHT=2
CONFIG_PANEL_LCD_WIDTH=20
CONFIG_PANEL_LCD_BWIDTH=40
CONFIG_PANEL_LCD_HWIDTH=64
CONFIG_PANEL_LCD_CHARSET=0
CONFIG_PANEL_LCD_PROTO=0
CONFIG_PANEL_LCD_PIN_E=14
CONFIG_PANEL_LCD_PIN_RS=17
CONFIG_PANEL_LCD_PIN_RW=16
CONFIG_PANEL_LCD_PIN_BL=0

This patch fixes both errors, as it fixes the define
Patch against current linux-next tree at Tue Dec 15 06:07:01 2009 +0100

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/panel/panel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index f98a524..95c93e8 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -378,7 +378,7 @@ static unsigned char lcd_bits[LCD_PORTS][LCD_BITS][BIT_STATES];
 
 #ifdef CONFIG_PANEL_LCD_CHARSET
 #undef DEFAULT_LCD_CHARSET
-#define DEFAULT_LCD_CHARSET
+#define DEFAULT_LCD_CHARSET CONFIG_PANEL_LCD_CHARSET
 #endif
 
 #endif /* DEFAULT_PROFILE == 0 */
-- 
1.6.4.4

