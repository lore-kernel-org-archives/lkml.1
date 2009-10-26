Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbZJZXTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbZJZXTu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 19:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754264AbZJZXTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 19:19:49 -0400
Received: from smtp1.kolej.mff.cuni.cz ([78.128.192.10]:64863 "EHLO
	smtp1.kolej.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbZJZXTt (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 19:19:49 -0400
X-Greylist: delayed 1273 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Oct 2009 19:19:48 EDT
X-Envelope-From: santiago@crfreenet.org
Date: Mon, 26 Oct 2009 23:59:30 +0100
From: Ondrej Zajicek <santiago@crfreenet.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       marek.vasut@gmail.com, eric.y.miao@gmail.com
Subject: [PATCH] 2.6.32-rc5 bug in Palm Tungsten C keyboard
Message-ID: <20091026225930.GA18723@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Debian GNU/Linux 4.0 (Etch)
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palm Tungsten C keyboard structure has swapped
rows/cols gpio structures and does not work.
This patch fixes it.

Signed-off-by: Ondrej Zajicek <santiago@crfreenet.org>

diff -uprN linux-2.6.32-rc5-old/arch/arm/mach-pxa/palmtc.c linux-2.6.32-rc5/arch/arm/mach-pxa/palmtc.c
--- linux-2.6.32-rc5-old/arch/arm/mach-pxa/palmtc.c	2009-10-16 02:41:50.000000000 +0200
+++ linux-2.6.32-rc5/arch/arm/mach-pxa/palmtc.c	2009-10-26 20:56:44.000000000 +0100
@@ -292,10 +292,10 @@ const static unsigned int palmtc_keypad_
 
 static struct matrix_keypad_platform_data palmtc_keypad_platform_data = {
 	.keymap_data	= &palmtc_keymap_data,
-	.col_gpios	= palmtc_keypad_row_gpios,
-	.num_col_gpios	= 12,
-	.row_gpios	= palmtc_keypad_col_gpios,
-	.num_row_gpios	= 4,
+	.row_gpios	= palmtc_keypad_row_gpios,
+	.num_row_gpios	= ARRAY_SIZE(palmtc_keypad_row_gpios),
+	.col_gpios	= palmtc_keypad_col_gpios,
+	.num_col_gpios	= ARRAY_SIZE(palmtc_keypad_col_gpios),
 	.active_low	= 1,
 
 	.debounce_ms		= 20,


-- 
Elen sila lumenn' omentielvo

Ondrej 'SanTiago' Zajicek (email: santiago@crfreenet.org)
OpenPGP encrypted e-mails preferred (KeyID 0x11DEADC3, wwwkeys.pgp.net)
"To err is human -- to blame it on a computer is even more so."
