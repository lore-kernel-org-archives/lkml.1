Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbZLMTMh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbZLMTMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 14:12:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753928AbZLMTMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 14:12:36 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:34416 "HELO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753927AbZLMTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 14:12:35 -0500
Date: Sun, 13 Dec 2009 20:07:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] ataflop: Killl warning about unused variable flags
Message-ID: <alpine.DEB.2.00.0912132006430.19895@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit e0c0978699a83f26f2341f7eedc1463b79e31aff ("ataflop: remove
buggy/commented-out IRQ disable from do_fd_request()") the `flags' variable
became unused:

drivers/block/ataflop.c:1473: warning: unused variable 'flags'

Hence remove it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/block/ataflop.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index a5af1d6..e35cf59 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1470,8 +1470,6 @@ repeat:
 
 void do_fd_request(struct request_queue * q)
 {
- 	unsigned long flags;
-
 	DPRINT(("do_fd_request for pid %d\n",current->pid));
 	while( fdc_busy ) sleep_on( &fdc_wait );
 	fdc_busy = 1;
-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
