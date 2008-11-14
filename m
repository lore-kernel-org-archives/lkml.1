Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYKNXiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYKNXiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:38:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYKNXiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:38:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:16778 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbYKNXiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:38:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=b0efbHHXAYdMCS94hhPRmc65/6UaUWAGJrGBSRcJlWpGWJV7k335hA7JUBvAtQ+Fvv
         dTz10U/QzdkvL2ggPRz1JwBxBx6yaNpCm/c6nB4synQ4W+FLOeJdWW6Ws6TJuXwvEPxL
         Y9krt+l2cRK3pC3pw3cWNOsFnebAm52QlmJKA=
Date: Sat, 15 Nov 2008 02:41:31 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: drivers/video/backlight/mbp_nvidia_bl.c:114: error: storage size
	of '__mod_dmi_device_table' isn't known
Message-ID: <20081114234131.GA28559@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How can this work, given that MODULE_DEVICE_TABLE line expands into

	extern const struct dmi_device_id __mod_dmi_device_table __attribute__ ((unused, alias("mbp_device_table")));
				^^^^^^
but there is no struct dmi_device_id, there is struct dmi_system_id?

commit 239cfbde1f5843c4a24199f117d5f67f637d72d5
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Tue Sep 16 16:25:24 2008 -0700

    Fix autoloading of MacBook Pro backlight driver.
    
    Use new MODULE_DEVICE_TABLE(dmi, ...) facility. There's no need for
    every driver to screw it up for themselves, when the alias can be
    generated automatically.
    
    Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

diff --git a/drivers/video/backlight/mbp_nvidia_bl.c b/drivers/video/backlight/mbp_nvidia_bl.c
index 385cba4..06964af 100644
--- a/drivers/video/backlight/mbp_nvidia_bl.c
+++ b/drivers/video/backlight/mbp_nvidia_bl.c
@@ -111,6 +111,4 @@ module_exit(mbp_exit);
 MODULE_AUTHOR("Matthew Garrett <mjg@redhat.com>");
 MODULE_DESCRIPTION("Nvidia-based Macbook Pro Backlight Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,1");
-MODULE_ALIAS("svnAppleInc.:pnMacBookPro3,2");
-MODULE_ALIAS("svnAppleInc.:pnMacBookPro4,1");
+MODULE_DEVICE_TABLE(dmi, mbp_device_table);
