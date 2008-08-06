Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbYHFUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbYHFUTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557AbYHFUTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:19:45 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:42493 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYHFUTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:19:44 -0400
Date: Wed, 6 Aug 2008 22:19:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: Alan Cox <alan@redhat.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68k/amiserial: fix fallout of tty break handling rework
Message-ID: <Pine.LNX.4.64.0808062218490.17614@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 9e98966c7bb94355689478bc84cc3e0c190f977e (tty: rework break handling)
forgot to update one exit point of rs_break() in the Amiga serial driver.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/amiserial.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1254,7 +1254,7 @@ static int rs_break(struct tty_struct *t
 	unsigned long flags;
 
 	if (serial_paranoia_check(info, tty->name, "rs_break"))
-		return;
+		return -EINVAL;
 
 	local_irq_save(flags);
 	if (break_state == -1)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
