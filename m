Return-Path: <linux-kernel-owner+w=401wt.eu-S1751540AbZL0V3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbZL0V3m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 16:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZL0V3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 16:29:41 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:41019 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZL0V3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 16:29:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=jr6IuV2SwESJcMkjoqTjCVl16/kGlJaujqyWpz79Zve/3oXpZ9xaCFH508tMmIGy8W
         CGz16rLUMTT47p2IK78Q9XjKziLX7t9mkfw08965Fu8t2JV1uT2P5MHy+F0cUk0cEGob
         YQIpYxxRGCQazlq7GHkQo4F/z5/Ur3Qr/zOFk=
Message-ID: <4B37D26F.4050002@gmail.com>
Date: Sun, 27 Dec 2009 22:32:31 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] w1: fix test in ds2482_wait_1wire_idle()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (++retries < DS2482_WAIT_IDLE_TIMEOUT)' retries reaches
DS2482_WAIT_IDLE_TIMEOUT after the loop

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/w1/masters/ds2482.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/w1/masters/ds2482.c b/drivers/w1/masters/ds2482.c
index 406caa6..e5f7441 100644
--- a/drivers/w1/masters/ds2482.c
+++ b/drivers/w1/masters/ds2482.c
@@ -214,7 +214,7 @@ static int ds2482_wait_1wire_idle(struct ds2482_data *pdev)
 			 (++retries < DS2482_WAIT_IDLE_TIMEOUT));
 	}
 
-	if (retries > DS2482_WAIT_IDLE_TIMEOUT)
+	if (retries >= DS2482_WAIT_IDLE_TIMEOUT)
 		printk(KERN_ERR "%s: timeout on channel %d\n",
 		       __func__, pdev->channel);
 
