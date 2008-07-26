Return-Path: <linux-kernel-owner+w=401wt.eu-S1755095AbYGZPPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbYGZPPW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 11:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751954AbYGZPPJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 11:15:09 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:44168 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbYGZPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 11:15:08 -0400
Date: Sat, 26 Jul 2008 17:15:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] dsp56k: Fix BKL pushdown
Message-ID: <Pine.LNX.4.64.0807261713560.16910@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 236b8756a2b6f90498d45b2c36d43e5372f2d4b8 (dsp56k: BKL pushdown) removed
the `struct inode *inode' parameter from dsp56k_ioctl(), but forgot to update
the use of `inode' in the first line of the function.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/char/dsp56k.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/char/dsp56k.c
+++ b/drivers/char/dsp56k.c
@@ -304,9 +304,9 @@ static ssize_t dsp56k_write(struct file 
 }
 
 static long dsp56k_ioctl(struct file *file, unsigned int cmd,
-							unsigned long arg)
+			 unsigned long arg)
 {
-	int dev = iminor(inode) & 0x0f;
+	int dev = iminor(file->f_path.dentry->d_inode) & 0x0f;
 	void __user *argp = (void __user *)arg;
 
 	switch(dev)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
