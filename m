Return-Path: <linux-kernel-owner+w=401wt.eu-S1763092AbYGaDAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763092AbYGaDAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 23:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYGaCwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 22:52:04 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:55977 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbYGaCwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 22:52:01 -0400
Date: Wed, 30 Jul 2008 21:50:29 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-kernel@vger.kernel.org
Subject: [PATCH 28/30] W1: ds2490.c ds_write_block remove extra ds_wait_status
Message-ID: <20080731025029.GC12181@spacedout.fries.net>
References: <20080729020433.GA24424@spacedout.fries.net> <20080729161356.2de456fb.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080729161356.2de456fb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Wed, 30 Jul 2008 21:50:30 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop the extra ds_wait_status() in ds_write_block().

Signed-off-by: David Fries <david@fries.net>
Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
---
 drivers/w1/masters/ds2490.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
index 29df1d2..4faf4f9 100644
--- a/drivers/w1/masters/ds2490.c
+++ b/drivers/w1/masters/ds2490.c
@@ -648,8 +648,6 @@ static int ds_write_block(struct ds_device *dev, u8 *buf, int len)
 	if (err < 0)
 		return err;
 
-	ds_wait_status(dev, &st);
-
 	err = ds_send_control(dev, COMM_BLOCK_IO | COMM_IM | COMM_SPU, len);
 	if (err)
 		return err;
-- 
1.4.4.4
