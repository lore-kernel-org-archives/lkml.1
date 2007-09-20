Return-Path: <linux-kernel-owner+w=401wt.eu-S1757842AbXITTKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbXITTKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbXITTKi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:10:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46570 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752261AbXITTKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:10:37 -0400
Message-Id: <20070920190627.549173271@linux-foundation.org>
References: <20070920190608.339749785@linux-foundation.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Sep 2007 12:06:09 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] fix OOPS in platform uevent
Content-Disposition: inline; filename=sysfs-oops.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Environment wasn't being NULL terminated.
Suggested by Kay Sievers

Fixes: http://bugzilla.kernel.org/show_bug.cgi?id=9034

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/base/platform.c	2007-06-25 09:03:10.000000000 -0700
+++ b/drivers/base/platform.c	2007-09-20 11:35:57.000000000 -0700
@@ -546,6 +546,7 @@ static int platform_uevent(struct device
 	struct platform_device	*pdev = to_platform_device(dev);
 
 	envp[0] = buffer;
+	envp[1] = NULL;
 	snprintf(buffer, buffer_size, "MODALIAS=%s", pdev->name);
 	return 0;
 }

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

