Return-Path: <linux-kernel-owner+w=401wt.eu-S1945985AbXEAUsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945985AbXEAUsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 16:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423665AbXEAUmL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 16:42:11 -0400
Received: from assei1bl6.telenet-ops.be ([195.130.133.68]:33416 "EHLO
	assei1bl6.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423617AbXEAUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 16:34:56 -0400
Message-Id: <20070501203333.407583654@mail.of.borg>
References: <20070501203234.252205858@mail.of.borg>
User-Agent: quilt/0.45-1
Date: Tue, 01 May 2007 22:32:48 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Subject: [patch 14/33] m68k: Atari SCSI workqueue updates
Content-Disposition: inline; filename=atari_NCR5380-work.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Workqueue updates for the Atari SCSI driver

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/atari_NCR5380.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-m68k-2.6.21.orig/drivers/scsi/atari_NCR5380.c
+++ linux-m68k-2.6.21/drivers/scsi/atari_NCR5380.c
@@ -657,7 +657,7 @@ static inline void NCR5380_print_phase(s
 #include <linux/interrupt.h>
 
 static volatile int main_running;
-static DECLARE_WORK(NCR5380_tqueue, (void (*)(void *))NCR5380_main, NULL);
+static DECLARE_WORK(NCR5380_tqueue, NCR5380_main);
 
 static inline void queue_main(void)
 {
@@ -1075,7 +1075,7 @@ static int NCR5380_queue_command(Scsi_Cm
  *  reenable them.  This prevents reentrancy and kernel stack overflow.
  */
 
-static void NCR5380_main(void *bl)
+static void NCR5380_main(struct work_struct *work)
 {
 	Scsi_Cmnd *tmp, *prev;
 	struct Scsi_Host *instance = first_instance;

--
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

