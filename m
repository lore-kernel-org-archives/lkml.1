Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbYESMex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbYESMex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758291AbYESMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:53 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:27605 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757246AbYESMbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:50 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [10/11] Use unlocked_fasync in RTC
Message-Id: <20080519123119.C2C7E1B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:19 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:17.0641 (UTC) FILETIME=[41E93D90:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just uses fasync_helper
Signed-off-by: Andi Kleen <ak@linux.intel.com>

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
