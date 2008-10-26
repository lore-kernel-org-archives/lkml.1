Return-Path: <linux-kernel-owner+w=401wt.eu-S1755349AbYJZOUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbYJZOUh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 10:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJZOU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 10:20:29 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:43250 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbYJZOU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 10:20:29 -0400
Date: Sun, 26 Oct 2008 15:20:26 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wolfgang Grandegger <wg@grandegger.com>, Jean Delvare <khali@linux-fr.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] hwmon: w83781d doesn't link when built-in
Message-ID: <Pine.LNX.4.64.0810261519410.15317@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When w83781d is built-in, the final links fails with the following vague error
message:

`.exit.text' referenced in section `.init.text' of drivers/built-in.o: defined
in discarded section `.exit.text' of drivers/built-in.o

w83781d_isa_unregister() cannot be marked __exit, as it's also called from
sensors_w83781d_init(), which is marked __init.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/hwmon/w83781d.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/w83781d.c
+++ b/drivers/hwmon/w83781d.c
@@ -1968,7 +1968,7 @@ exit:
 	return res;
 }
 
-static void __exit
+static void
 w83781d_isa_unregister(void)
 {
 	if (pdev) {
@@ -2017,7 +2017,7 @@ w83781d_isa_register(void)
 	return 0;
 }
 
-static void __exit
+static void
 w83781d_isa_unregister(void)
 {
 }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
