Return-Path: <linux-kernel-owner+w=401wt.eu-S935474AbXFFVcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935474AbXFFVcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763453AbXFFVcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:32:42 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:41895 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758568AbXFFVcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:32:42 -0400
Date: Wed, 6 Jun 2007 23:32:38 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: i2c@lm-sensors.org
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: i2c module aliases
Message-ID: <Pine.LNX.4.64.0706062325270.30244@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From browsing through file2alias.c, I have the impression there's a
missing TO_NATIVE() conversion in the handling of 16-bit (hence,
endian-affected) i2c IDs.
This will cause the module aliases to be incorrect when cross-compiling
for a system with a different endianness.  Is that correct?
If yes, the patch below adds the missing conversion.

Of course, no driver seems to use `MODULE_DEVICE_TABLE(i2c, ...)' yet,
hence nobody noticed.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -390,6 +390,7 @@ static int do_vio_entry(const char *file
 
 static int do_i2c_entry(const char *filename, struct i2c_device_id *i2c, char *alias)
 {
+	i2c->id = TO_NATIVE(i2c->id);
 	strcpy(alias, "i2c:");
 	ADD(alias, "id", 1, i2c->id);
 	return 1;

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
