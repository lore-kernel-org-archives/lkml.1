Return-Path: <linux-kernel-owner+w=401wt.eu-S935040AbYBGVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935040AbYBGVPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933769AbYBGUys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:54:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762804AbYBGUyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:54:44 -0500
Date: Thu, 7 Feb 2008 12:48:24 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael E Brown <michael_e_brown@dell.com>
Subject: [patch 44/45] Driver core: Revert "Fix Firmware class name
	collision"
Message-ID: <20080207204824.GS16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="driver-core-revert-fix-firmware-class-name-collision.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael E Brown <Michael_E_Brown@dell.com>

patch 7d640c4a5b36c4733460065db1554da924044511 in mainline.

This reverts commit 109f0e93b6b728f03c1eb4af02bc25d71b646c59.

The original patch breaks BIOS updates on all Dell machines. The path to
the firmware file for the dell_rbu driver changes, which breaks all of
the userspace tools which rely on it.

Note that this patch re-introduces a problem with i2c name collision
that was previously fixed by this patch.

Signed-off-by: Michael E Brown <michael_e_brown@dell.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/base/firmware_class.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -292,7 +292,8 @@ firmware_class_timeout(u_long data)
 
 static inline void fw_setup_device_id(struct device *f_dev, struct device *dev)
 {
-	snprintf(f_dev->bus_id, BUS_ID_SIZE, "firmware-%s", dev->bus_id);
+	/* XXX warning we should watch out for name collisions */
+	strlcpy(f_dev->bus_id, dev->bus_id, BUS_ID_SIZE);
 }
 
 static int fw_register_device(struct device **dev_p, const char *fw_name,

-- 
