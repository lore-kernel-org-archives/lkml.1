Return-Path: <linux-kernel-owner+w=401wt.eu-S1762162AbYEETQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762162AbYEETQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYEETPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:15:52 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:38076 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYEETPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:15:51 -0400
Date: Mon, 5 May 2008 21:15:48 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k: serial167 missing return value in cy_put_char()
Message-ID: <Pine.LNX.4.64.0805052115240.17727@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

    commit a5b08c66194fba02a865b397579b7204688bcb1e
    Author: Alan Cox <alan@lxorguk.ukuu.org.uk>
    Date:   Wed Apr 30 00:54:05 2008 -0700

    serial167: switch to int put_char method

missed one case when adding return values.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/serial167.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1073,7 +1073,7 @@ static int cy_put_char(struct tty_struct
 		return 0;
 
 	if (!info->xmit_buf)
-		return;
+		return 0;
 
 	local_irq_save(flags);
 	if (info->xmit_cnt >= PAGE_SIZE - 1) {

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
