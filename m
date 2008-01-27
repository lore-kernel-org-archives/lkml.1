Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYA0N3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYA0N3o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 08:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbYA0N3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 08:29:35 -0500
Received: from agave.telenet-ops.be ([195.130.137.77]:50467 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753633AbYA0N3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 08:29:34 -0500
X-Greylist: delayed 3275 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2008 08:29:34 EST
Date: Sun, 27 Jan 2008 14:29:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] Atari Falcon IDE: Add missing hwif variable
Message-ID: <Pine.LNX.4.64.0801271428390.9257@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Atari Falcon IDE: Add missing hwif variable

Commit cbb010c180294a5242a7681555c28737d9dd26ab

    ide: drop 'initializing' argument from ide_register_hw()

    * Rename init_hwif_data() to ide_init_port_data() and export it.
    
    * For all users of ide_register_hw() with 'initializing' argument set
      hwif->present and hwif->hold are always zero so convert these host
      drivers to use ide_find_port()+ide_init_port_data()+ide_init_port_hw()
      instead (also no need for init_hwif_default() call since the setup
      done by it gets over-ridden by ide_init_port_hw() call).
    
    * Drop 'initializing' argument from ide_register_hw().
    
introduced the usage of a hwif variable, but forgot to declare the actual
variable.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
---
 drivers/ide/legacy/falconide.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ide/legacy/falconide.c
+++ b/drivers/ide/legacy/falconide.c
@@ -66,6 +66,7 @@ static int __init falconide_init(void)
 {
     if (MACH_IS_ATARI && ATARIHW_PRESENT(IDE)) {
 	hw_regs_t hw;
+	ide_hwif_t *hwif;
 
 	printk(KERN_INFO "ide: Falcon IDE controller\n");
 

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
