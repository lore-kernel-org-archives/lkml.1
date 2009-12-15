Return-Path: <linux-kernel-owner+w=401wt.eu-S933739AbZLOVpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933739AbZLOVpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 16:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932892AbZLOVpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 16:45:01 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:41073 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201AbZLOVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 16:45:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JanADPMTY2nLZhIRK+WMv5r+c+19Ot/5W47LNf/DuHPGcttUnNsHxhY3NSzdix6X8z
         WQyXoBWOR5pTmJYMxhEwUx0VrA6hDSF6fJxnyNUGVBcmYgMFICWgaBr51g5bUSAnD/hS
         P21RT9qUaCzawe3bYh/TGqXJZIvxt1OicUY3c=
Message-ID: <4B2803CA.5020101@gmail.com>
Date: Tue, 15 Dec 2009 22:46:50 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Zhang Rui <rui.zhang@intel.com>,
       Matthew Garrett <mjg@redhat.com>
Subject: [PATCH] thermal: Fix test of unsigned in thermal_cooling_device_cur_state_store()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

state is unsigned long so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

Is this the best way to fix this?

diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
index 6f8d8f9..800e0c5 100644
--- a/drivers/thermal/thermal_sys.c
+++ b/drivers/thermal/thermal_sys.c
@@ -374,7 +374,7 @@ thermal_cooling_device_cur_state_store(struct device *dev,
 	if (!sscanf(buf, "%ld\n", &state))
 		return -EINVAL;
 
-	if (state < 0)
+	if ((long)state < 0)
 		return -EINVAL;
 
 	result = cdev->ops->set_cur_state(cdev, state);
