Return-Path: <linux-kernel-owner+w=401wt.eu-S1759343AbZAHMO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759343AbZAHMO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 07:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752779AbZAHMOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 07:14:32 -0500
Received: from mercury.realtime.net ([205.238.132.86]:37581 "EHLO
	mercury.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbZAHMOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 07:14:31 -0500
Subject: [PATCH 2/4] hvc_console: use kzalloc
From: Milton Miller <miltonm@bga.com>
To: Christian Borntraeger <borntraeger@de.ibm.com>,
       Benjiman Herrenschmidt <benh@kernel.crashing.org>
cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       lkml <linux-kernel@vger.kernel.org>, Joe Peterson <joe@skyrush.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Message-Id: <hvc-console-29-3-2@bga.com>
In-Reply-To: : <hvc-console-29-3@bga.com>
Date: Thu, 08 Jan 2009 06:14:28 -0600
X-Originating-IP: 205.232.218.56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace kmalloc + memset  with kzalloc.

Signed-off-by: Milton Miller <miltonm@bga.com>

Index: work.git/drivers/char/hvc_console.c
===================================================================
--- work.git.orig/drivers/char/hvc_console.c	2009-01-08 04:24:10.000000000 -0600
+++ work.git/drivers/char/hvc_console.c	2009-01-08 04:24:35.000000000 -0600
@@ -765,13 +765,11 @@ struct hvc_struct __devinit *hvc_alloc(u
 			return ERR_PTR(err);
 	}
 
-	hp = kmalloc(ALIGN(sizeof(*hp), sizeof(long)) + outbuf_size,
+	hp = kzalloc(ALIGN(sizeof(*hp), sizeof(long)) + outbuf_size,
 			GFP_KERNEL);
 	if (!hp)
 		return ERR_PTR(-ENOMEM);
 
-	memset(hp, 0x00, sizeof(*hp));
-
 	hp->vtermno = vtermno;
 	hp->data = data;
 	hp->ops = ops;
