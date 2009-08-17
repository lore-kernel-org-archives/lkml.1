Return-Path: <linux-kernel-owner+w=401wt.eu-S1756932AbZHQQLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932AbZHQQLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 12:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbZHQQLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 12:11:45 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:35447 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036AbZHQQLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 12:11:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bgUO6W/hDmlrr41u0+5Sp7FO0rjM7+jBUu1SXqnDtkqWXFus+9lnOiwFV4nr5Opt9m
         wuqkYoIfGlyNMItDNKJr7rSLCvmSkako48piBc6ou+DuEDUvl1IwlvPy+q/Hb4e3J1lw
         FaOC2fh9mOftGqOccK/4k9kcOxfWd8mNib1NI=
Message-ID: <4A89813A.4060603@gmail.com>
Date: Mon, 17 Aug 2009 09:11:38 -0700
From: Joonwoo Park <joonwpark81@gmail.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071020)
MIME-Version: 1.0
To: Rodolfo Giometti <giometti@enneenne.com>,
       Linux PPS <linuxpps@ml.enneenne.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] pps: fix incorrect verdict check
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joonwoo Park <joonwpark81@gmail.com>

Fix incorrect verdict check and returns error if device_create failed,
otherwise driver triggers kernel oops.

Signed-off-by: Joonwoo Park<joonwpark81@gmail.com>
---
 drivers/pps/pps.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index ac8cc8c..fea17e7 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -244,7 +244,7 @@ int pps_register_cdev(struct pps_device *pps)
 	}
 	pps->dev = device_create(pps_class, pps->info.dev, pps->devno, NULL,
 							"pps%d", pps->id);
-	if (err)
+	if (IS_ERR(pps->dev))
 		goto del_cdev;
 	dev_set_drvdata(pps->dev, pps);
 
-- 
1.5.5.1

