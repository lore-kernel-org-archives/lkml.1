Return-Path: <linux-kernel-owner+w=401wt.eu-S1759669AbZDRURp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbZDRURp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 16:17:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZDRURg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 16:17:36 -0400
Received: from smtpfb1-g21.free.fr ([212.27.42.9]:49784 "EHLO
	smtpfb1-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbZDRURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 16:17:35 -0400
Date: Sat, 18 Apr 2009 22:17:17 +0200
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, torvalds@osdl.org,
       stable@kernel.org
Subject: [PATCH] Please revert console ASCII glyph 1:1 mapping
Message-ID: <20090418201717.GL21409@const>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@osdl.org, stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 1c55f187 (console ASCII glyph 1:1 mapping):  Ingo
was assuming that reverting to 1:1 mapping for chars >= 128 was not
useful, but it happens to be: due to the limitations of the Linux
console, when a blind user wants to read BIG5 on it, he has no other
way than loading a font without SFM and let the 1:1 mapping permit the
screen reader to get the BIG5 encoding.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

reverted:
--- b/drivers/char/vt.c
+++ a/drivers/char/vt.c
@@ -2274,7 +2274,7 @@
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
-				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) && c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
 				       This would make absolutely no sense with Unicode in mind,
 				       but do this for ASCII characters since a font may lack
