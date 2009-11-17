Return-Path: <linux-kernel-owner+w=401wt.eu-S1753234AbZKQNvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234AbZKQNvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 08:51:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZKQNvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 08:51:07 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:60063 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbZKQNvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 08:51:07 -0500
X-IronPort-AV: E=Sophos;i="4.44,758,1249250400"; 
   d="scan'208";a="36894948"
Date: Tue, 17 Nov 2009 14:51:11 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] Fix braille keyboard keysym generation
Message-ID: <20091117135111.GA14470@const.bordeaux.inria.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	alan@lxorguk.ukuu.org.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keysyms stored in key_map[] are not simply K() values, but U(K())
values, as can be seen in the KDSKBENT ioctl handler.  The
kernel-generated braille keysyms thus need a U() call too.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

diff --git a/drivers/char/keyboard.c b/drivers/char/keyboard.c
index 737be95..82c493e 100644
--- a/drivers/char/keyboard.c
+++ b/drivers/char/keyboard.c
@@ -1249,7 +1249,7 @@ static void kbd_keycode(unsigned int keycode, int down, int hw_raw)
 
 	if (keycode >= NR_KEYS)
 		if (keycode >= KEY_BRL_DOT1 && keycode <= KEY_BRL_DOT8)
-			keysym = K(KT_BRL, keycode - KEY_BRL_DOT1 + 1);
+			keysym = U(K(KT_BRL, keycode - KEY_BRL_DOT1 + 1));
 		else
 			return;
 	else
