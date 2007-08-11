Return-Path: <linux-kernel-owner+w=401wt.eu-S1763087AbXHKS7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763087AbXHKS7V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762303AbXHKS6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:58:10 -0400
Received: from 1wt.eu ([62.212.114.60]:1485 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762148AbXHKS6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:58:07 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184834.%N@1wt.eu>
References: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 21:47:57 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [2.6.20.16 review 05/28] Char: cyclades, fix deadlock
Content-Disposition: inline; filename=0005-PATCH-Char-cyclades-fix-deadlock.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

An omitted unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/cyclades.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 3ffa080..e4e0ccb 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1102,6 +1102,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 
 				if (data & info->ignore_status_mask) {
 					info->icount.rx++;
+					spin_unlock(&cinfo->card_lock);
 					return;
 				}
 				if (tty_buffer_request_room(tty, 1)) {
-- 
1.5.2.4

-- 
