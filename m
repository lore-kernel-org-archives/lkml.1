Return-Path: <linux-kernel-owner+w=401wt.eu-S1759671AbZJPN02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671AbZJPN02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 09:26:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759514AbZJPN01
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 09:26:27 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:56381 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500AbZJPN00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 09:26:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=p/jXMpEsQ2KJXRscmYTPzlRqLHV6ev+A/CMAAG/o1zv1Ltu1mRK8lWmGSkNt022gey
         prFxS4JkYTBZl06VtCABiJqVtCDpMRjxLGyGp7ehlKmTpJWBDgQHtmyt6pgniUKZjUBn
         xfTgHzxS4RzTdth2E5UoNFg9IStK8Xjd0Mi54=
Message-ID: <4AD8769E.4060702@gmail.com>
Date: Fri, 16 Oct 2009 15:35:26 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: len.brown@intel.com, rui.zhang@intel.com,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] thermal: Fix check of unsigned in thermal_cooling_device_cur_state_store()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

state is unsigned long so the test does not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Is this the right fix? please review.

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 4e83c29..04970bf 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -374,7 +374,7 @@ thermal_cooling_device_cur_state_store(struct device *dev,
 	if (!sscanf(buf, "%ld\n", &state))
 		return -EINVAL;
 
-	if (state < 0)
+	if ((long)state < 0)
 		return -EINVAL;
 
 	result = cdev->ops->set_cur_state(cdev, state);
