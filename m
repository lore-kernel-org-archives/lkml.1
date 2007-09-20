Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbXITTK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbXITTK7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750885AbXITTKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:10:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48164 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbXITTKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:10:48 -0400
Message-Id: <20070920190627.619372296@linux-foundation.org>
References: <20070920190608.339749785@linux-foundation.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Sep 2007 12:06:10 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] missing null termination in power supply uevent
Content-Disposition: inline; filename=sysfs-power.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Need to null terminate environment. Found by inspection
while looking for similar problems to platform uevent bug

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>


--- a/drivers/power/power_supply_sysfs.c	2007-08-18 07:50:10.000000000 -0700
+++ b/drivers/power/power_supply_sysfs.c	2007-09-20 11:42:11.000000000 -0700
@@ -289,6 +289,7 @@ int power_supply_uevent(struct device *d
 		if (ret)
 			goto out;
 	}
+	envp[i] = NULL;
 
 out:
 	free_page((unsigned long)prop_buf);

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

