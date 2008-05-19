Return-Path: <linux-kernel-owner+w=401wt.eu-S1760179AbYESMfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179AbYESMfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 08:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759194AbYESMbx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 08:31:53 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:11599 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620AbYESMbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 08:31:51 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080519231.561421028@firstfloor.org>
In-Reply-To: <20080519231.561421028@firstfloor.org>
To: clemens@ladisch.de, corbet@lwn.net, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/11] Convert hpet to unlocked_fasync
Message-Id: <20080519123118.BDD111B41FF@basil.firstfloor.org>
Date: Mon, 19 May 2008 14:31:18 +0200 (CEST)
X-OriginalArrivalTime: 19 May 2008 12:24:16.0625 (UTC) FILETIME=[414E3610:01C8B9AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just calls fasync_helper and private structure is protected by 
file reference count.

Cc: clemens@ladisch.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>

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
 
