Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345AbYKNHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbYKNHy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYKNHyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:54:49 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:35360 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYKNHys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:54:48 -0500
Date: Fri, 14 Nov 2008 08:54:46 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rodolfo Giometti <giometti@linux.it>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       kernel-janitors@vger.kernel.org
Subject: [PATCH] misc: C2port needs <linux/sched.h>
Message-ID: <Pine.LNX.4.64.0811140853320.11953@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

m68k allmodconfig:

| drivers/misc/c2port/core.c: In function 'c2port_reset':
| drivers/misc/c2port/core.c:73: error: dereferencing pointer to incomplete type
| drivers/misc/c2port/core.c: In function 'c2port_strobe_ck':
| drivers/misc/c2port/core.c:91: error: dereferencing pointer to incomplete type

Include <linux/sched.h> to fix it, as m68k's local_irq_enable() needs to know
about struct task_struct.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Apparently never been in linux-next.

Janitors: anyone who has time to extract struct task_struct into its own
header file?

 drivers/misc/c2port/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -18,6 +18,7 @@
 #include <linux/ctype.h>
 #include <linux/delay.h>
 #include <linux/idr.h>
+#include <linux/sched.h>
 
 #include <linux/c2port.h>
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
