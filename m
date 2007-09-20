Return-Path: <linux-kernel-owner+w=401wt.eu-S1758690AbXITTLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758690AbXITTLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 15:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXITTLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 15:11:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51265 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752935AbXITTLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 15:11:15 -0400
Message-Id: <20070920190627.671886126@linux-foundation.org>
References: <20070920190608.339749785@linux-foundation.org>
User-Agent: quilt/0.46-1
Date: Thu, 20 Sep 2007 12:06:11 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] missing null termination in one wire uevent
Content-Disposition: inline; filename=sysfs-wl.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Need to null terminate environment. Found by inspection
while looking for similar problems to platform uevent bug

Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>

--- a/drivers/w1/w1.c	2007-08-18 07:50:12.000000000 -0700
+++ b/drivers/w1/w1.c	2007-09-20 11:44:06.000000000 -0700
@@ -431,6 +431,7 @@ static int w1_uevent(struct device *dev,
 	err = add_uevent_var(envp, num_envp, &cur_index, buffer, buffer_size,
 			&cur_len, "W1_SLAVE_ID=%024LX",
 			(unsigned long long)sl->reg_num.id);
+	envp[cur_index] = NULL;
 	if (err)
 		return err;
 

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

