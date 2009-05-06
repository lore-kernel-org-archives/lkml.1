Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbZEFPP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbZEFPP2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 11:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZEFPPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 11:15:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54961 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751071AbZEFPPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 11:15:02 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] dereferencing freed in saa5246a.c
To: torvalds@linux-foundation.org, mchehab@redhat.com,
       linux-kernel@vger.kernel.org
Date: Wed, 06 May 2009 17:13:33 +0100
Message-ID: <20090506161317.24311.48890.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090506161238.24311.27127.stgit@t61.ukuu.org.uk>
References: <20090506161238.24311.27127.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

I lowered the kfree(t) down a couple lines and removed the superflous
"t->vdev = NULL;"

regards,
dan carpenter

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/video/saa5246a.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/drivers/media/video/saa5246a.c b/drivers/media/video/saa5246a.c
index da47b2f..155804b 100644
--- a/drivers/media/video/saa5246a.c
+++ b/drivers/media/video/saa5246a.c
@@ -1092,9 +1092,8 @@ static int saa5246a_probe(struct i2c_client *client,
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

