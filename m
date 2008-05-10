Return-Path: <linux-kernel-owner+w=401wt.eu-S1757539AbYEJTNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539AbYEJTNd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 15:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbYEJTNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 15:13:25 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:17449 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbYEJTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 15:13:24 -0400
Date: Sat, 10 May 2008 12:13:03 -0700 (PDT)
From: Chris Peterson <cpeterso@cpeterso.com>
To: paulkf@microgate.com
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] char/synclink_gt: fix uninitialized return value in put_char()
Message-ID: <Pine.LNX.4.62.0805101209430.4183@ikari.dreamhost.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


put_char() can return an uninitialized value of 'ret' in one code path.

Signed-off-by: Chris Peterson <cpeterso@cpeterso.com>
---
--- linux-2.6.25-rc1-git7-before/drivers/char/synclink_gt.c	2008-05-10 11:43:19.000000000 -0700
+++ linux-2.6.25-rc1-git7-after/drivers/char/synclink_gt.c	2008-05-10 11:51:22.000000000 -0700
@@ -927,6 +927,8 @@ static int put_char(struct tty_struct *t
 	if (!info->tx_active && (info->tx_count < info->max_frame_size)) {
 		info->tx_buf[info->tx_count++] = ch;
 		ret = 1;
+	} else {
+		ret = 0;
 	}
 	spin_unlock_irqrestore(&info->lock,flags);
 	return ret;
