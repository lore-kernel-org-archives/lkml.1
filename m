Return-Path: <linux-kernel-owner+w=401wt.eu-S934879AbYETPem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934879AbYETPem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 11:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932873AbYETPag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 11:30:36 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:2881 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbYETPab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 11:30:31 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080520528.793382059@firstfloor.org>
In-Reply-To: <20080520528.793382059@firstfloor.org>
To: mpm@selenic.com, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [8/11] Use unlocked_fasync in random.c
Message-Id: <20080520152849.EF6261B4204@basil.firstfloor.org>
Date: Tue, 20 May 2008 17:28:49 +0200 (CEST)
X-OriginalArrivalTime: 20 May 2008 15:21:47.0871 (UTC) FILETIME=[385B1EF0:01C8BA8D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just uses fasync_helper which does its own locking

Cc: mpm@selenic.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/random.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 
