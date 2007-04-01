Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXDAMrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXDAMrq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 08:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXDAMrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 08:47:46 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:53275 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886AbXDAMrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 08:47:46 -0400
Date: Sun, 1 Apr 2007 14:47:44 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fbcon: don't draw cursor when it's disabled
Message-ID: <20070401124744.GB4040@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Januszewski <spock@gentoo.org>

When the cursor and echo are disabled on the current console, pressing a
key will cause a black rectangle to be painted in the cursor's position.
Fix this by not touching the framebuffer in fbcon_cursor() when the
cursor is off.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---

 drivers/video/console/fbcon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index f721341..7089aa8 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1330,7 +1330,7 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 	int y;
  	int c = scr_readw((u16 *) vc->vc_pos);
 
-	if (fbcon_is_inactive(vc, info))
+	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;

