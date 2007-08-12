Return-Path: <linux-kernel-owner+w=401wt.eu-S932545AbXHLJLU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbXHLJLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:11:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327AbXHLJLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:11:09 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4852 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbXHLJLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:11:08 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/md/dm-crypt.c: potential memleak fix
Date: Sun, 12 Aug 2007 11:11:03 +0200
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121111.03725.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes a potential memleak on error path in dm-crypt code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-crypt.c | 26204 -> 26219 (+15 bytes)
 drivers/md/dm-crypt.o | 142872 -> 142872 (0 bytes)

 drivers/md/dm-crypt.c |    1 +
 1 file changed, 1 insertion(+)

--- linux-2.6.23-rc2-mm2-a/drivers/md/dm-crypt.c	2007-08-10 12:46:08.000000000 +0200
+++ linux-2.6.23-rc2-mm2-b/drivers/md/dm-crypt.c	2007-08-12 09:10:22.000000000 +0200
@@ -175,6 +175,7 @@ static int crypt_iv_essiv_ctr(struct cry

 	if (err) {
 		ti->error = "Error calculating hash in ESSIV";
+		kfree(salt);
 		return err;
 	}

