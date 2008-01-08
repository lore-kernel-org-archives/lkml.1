Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbYAHInX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbYAHInX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 03:43:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYAHInO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 03:43:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:22699 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbYAHInO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 03:43:14 -0500
Date: Tue, 8 Jan 2008 11:43:04 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@openvz.org
Subject: [PATCH -mm 1/4] genhd: fixup kobj_to_dev() macro
Message-ID: <20080108084304.GA6209@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please, fold into gregkh-driver-block-device.patch
-------------------------------------------------------
[PATCH -mm 1/4] genhd: fixup kobj_to_dev() macro

>From Pavel Emelyanov <xemul@openvz.org>

Using "kobj" twice is not OK, because substitution will be done twice
resulting in compile breakage if variable name is different from
structure member name.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 include/linux/genhd.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -13,7 +13,7 @@
 
 #ifdef CONFIG_BLOCK
 
-#define kobj_to_dev(kobj) container_of(kobj, struct device, kobj)
+#define kobj_to_dev(k) container_of(k, struct device, kobj)
 #define dev_to_disk(device) container_of(device, struct gendisk, dev)
 #define dev_to_part(device) container_of(device, struct hd_struct, dev)
 

