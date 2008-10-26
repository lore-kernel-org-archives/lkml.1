Return-Path: <linux-kernel-owner+w=401wt.eu-S1755229AbYJZOTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbYJZOTl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYJZOTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:19:33 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:60636 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbYJZOTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:19:32 -0400
Date: Sun, 26 Oct 2008 15:19:20 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Dennis Aberilla <denzzzhome@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: ds3234 doesn't link when built-in
Message-ID: <Pine.LNX.4.64.0810261518010.15317@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ds3234 is built-in, the final links fails with the following vague error
message:

`.exit.text' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

ds3234_remove() cannot be marked __exit, as it's accessed via __devexit_p().
In addition, mark ds3234_probe() __devinit while we're at it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/rtc/rtc-ds3234.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/rtc/rtc-ds3234.c
+++ b/drivers/rtc/rtc-ds3234.c
@@ -189,7 +189,7 @@ static const struct rtc_class_ops ds3234
 	.set_time	= ds3234_set_time,
 };
 
-static int ds3234_probe(struct spi_device *spi)
+static int __devinit ds3234_probe(struct spi_device *spi)
 {
 	struct rtc_device *rtc;
 	unsigned char tmp;
@@ -249,7 +249,7 @@ static int ds3234_probe(struct spi_devic
 	return 0;
 }
 
-static int __exit ds3234_remove(struct spi_device *spi)
+static int __devexit ds3234_remove(struct spi_device *spi)
 {
 	struct ds3234 *chip = platform_get_drvdata(spi);
 	struct rtc_device *rtc = chip->rtc;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
