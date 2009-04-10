Return-Path: <linux-kernel-owner+w=401wt.eu-S1764053AbZDJJCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764053AbZDJJCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 05:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755072AbZDJJCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 05:02:32 -0400
Received: from mail-qy0-f118.google.com ([209.85.221.118]:56399 "EHLO
	mail-qy0-f118.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbZDJJCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 05:02:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:user-agent:mime-version
         :content-type;
        b=e+A6gs+tQpXENvvqjxGE0x1UcachINZV1dcs0POx2pXpD0Ui5gG5E4NV6mbIdzKdtG
         S0RrIz1Yyt5MZwspoy7Q0Etmvmag/JvVDXSkHZb05xgh27itMhqkTQbv3Qi9fqbWtTOU
         OqeKW1a/I/4ONZUeTIU0dXS4szfKWRS258F90=
Date: Fri, 10 Apr 2009 12:02:13 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
X-X-Sender: dcarpenter@bicker
To: linux-kernel@vger.kernel.org
Subject: [patch] dereferencing freed in saa5246a.c
Message-ID: <alpine.DEB.2.00.0904101153480.6129@bicker>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I lowered the kfree(t) down a couple lines and removed the superflous 
"t->vdev = NULL;"

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/drivers/media/video/saa5246a.c	2009-04-09 23:50:25.000000000 +0300
+++ devel/drivers/media/video/saa5246a.c	2009-04-09 23:51:26.000000000 +0300
@@ -1092,9 +1092,8 @@
 	/* Register it */
 	err = video_register_device(t->vdev, VFL_TYPE_VTX, -1);
 	if (err < 0) {
-		kfree(t);
 		video_device_release(t->vdev);
-		t->vdev = NULL;
+		kfree(t);
 		return err;
 	}
 	return 0;
