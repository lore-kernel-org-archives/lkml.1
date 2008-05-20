Return-Path: <linux-kernel-owner+w=401wt.eu-S935019AbYETPfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935019AbYETPfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932940AbYETPah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:37 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:35658 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932841AbYETPaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:35 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/11] Use unlocked_fasync in RTC
Message-Id: <20080520152852.04FB51B4204@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:52 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:50.0808 (UTC) FILETIME=[3A1B4580:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just uses fasync_helper
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/rtc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/char/rtc.c
===================================================================
--- linux.orig/drivers/char/rtc.c
+++ linux/drivers/char/rtc.c
@@ -913,7 +913,7 @@ static const struct file_operations rtc_
 	.ioctl		= rtc_ioctl,
 	.open		= rtc_open,
 	.release	= rtc_release,
-	.fasync		= rtc_fasync,
+	.unlocked_fasync = rtc_fasync,
 };
 
 static struct miscdevice rtc_dev = {
