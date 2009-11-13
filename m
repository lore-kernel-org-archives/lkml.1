Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbZKMPK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbZKMPK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 10:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbZKMPKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 10:10:19 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:36524 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZKMPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 10:09:10 -0500
Message-Id: <20091113150917.750306597@de.ibm.com>
User-Agent: quilt/0.48-1
Date: Fri, 13 Nov 2009 16:09:11 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sebastian Ott <sebott@linux.vnet.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 47/52] [PATCH] cio: handle failed disable_subchannel after device recognition
References: <20091113150824.351347652@de.ibm.com>
Content-Disposition: inline; filename=146-cio-failed-disable-subchannel.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Ott <sebott@linux.vnet.ibm.com>

Handle a failing cio_disable_subchannel at the end of our device
recognition as if the recognition itself failed. This way
subsequent registration steps do not need to handle enabled
subchannels.

Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/cio/device_fsm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: quilt-2.6/drivers/s390/cio/device_fsm.c
===================================================================
--- quilt-2.6.orig/drivers/s390/cio/device_fsm.c	2009-11-13 16:08:22.000000000 +0100
+++ quilt-2.6/drivers/s390/cio/device_fsm.c	2009-11-13 16:08:22.000000000 +0100
@@ -229,7 +229,8 @@
 
 	sch = to_subchannel(cdev->dev.parent);
 
-	cio_disable_subchannel(sch);
+	if (cio_disable_subchannel(sch))
+		state = DEV_STATE_NOT_OPER;
 	/*
 	 * Now that we tried recognition, we have performed device selection
 	 * through ssch() and the path information is up to date.

