Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbYETPbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbYETPbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932098AbYETPa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:27 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2881 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758494AbYETPa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:26 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: clemens@ladisch.de, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/11] Convert hpet to unlocked_fasync
Message-Id: <20080520152851.002131B4203@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:50 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:50.0168 (UTC) FILETIME=[39B99D80:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just calls fasync_helper and private structure is protected by 
file reference count.

Cc: clemens@ladisch.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/hpet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/char/hpet.c
===================================================================
--- linux.orig/drivers/char/hpet.c
+++ linux/drivers/char/hpet.c
@@ -585,7 +585,7 @@ static const struct file_operations hpet
 	.ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
-	.fasync = hpet_fasync,
+	.unlocked_fasync = hpet_fasync,
 	.mmap = hpet_mmap,
 };
 
