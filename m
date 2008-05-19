Return-Path: <linux-kernel-owner+w=401wt.eu-S1759562AbYESMdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759562AbYESMdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757091AbYESMbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:49 -0400
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:27605 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756868AbYESMbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:47 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: mpm@selenic.com, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/11] Use unlocked_fasync in random.c
Message-Id: <20080519123117.B7FBD1B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:17 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:15.0594 (UTC) FILETIME=[40B0E4A0:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just uses fasync_helper which does its own locking

Cc: mpm@selenic.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux/drivers/char/random.c
===================================================================
--- linux.orig/drivers/char/random.c
+++ linux/drivers/char/random.c
@@ -1121,7 +1121,7 @@ const struct file_operations random_fops
 	.write = random_write,
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
-	.fasync = random_fasync,
+	.unlocked_fasync = random_fasync,
 	.release = random_release,
 };
 
@@ -1129,7 +1129,7 @@ const struct file_operations urandom_fop
 	.read  = urandom_read,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
-	.fasync = random_fasync,
+	.unlocked_fasync = random_fasync,
 	.release = random_release,
 };
 
