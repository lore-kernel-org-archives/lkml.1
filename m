Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbYETJ6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbYETJ6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764769AbYETJys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:54:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:24860 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764954AbYETJyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=l2Lmc0jMLirbCJtir3X+mGWWU8qFiazMfQbE0rfO4sP1CHjPCdQySZnlFfzIQ6/h3CuqJMUbrxcY18iILW91iE+K1sj0r6m57hwX1cMPxhktfapBkgO6JAVYKGeYvosPkSQcfL+N0+bWUKkHWxaBrES9XEuGsaCMaz2dlWXMxUk=
Date: Tue, 20 May 2008 17:55:54 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: greg@kroah.com, matthew@wil.cx, kay.sievers@vrfy.org,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/3][-mm] add class_reclassify macro
Message-ID: <20080520095553.GA3201@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Converting class semaphore to mutex cause lockdep warnings due to
class_interface_register/unregister will possible call device_add/del

For the class_interface users here add a class_reclassify macro to
reclassify the lock class of their struct class.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>

---
include/linux/device.h |    7 +++++++
1 file changed, 7 insertions(+)

--- linux/include/linux/device.h	2008-05-19 12:29:54.000000000 +0800
+++ linux.new/include/linux/device.h	2008-05-19 14:42:25.000000000 +0800
@@ -529,4 +529,11 @@ extern const char *dev_driver_string(str
 	MODULE_ALIAS("char-major-" __stringify(major) "-" __stringify(minor))
 #define MODULE_ALIAS_CHARDEV_MAJOR(major) \
 	MODULE_ALIAS("char-major-" __stringify(major) "-*")
+
+#define class_reclassify(class)						\
+do {									\
+	static struct lock_class_key	class_key;			\
+	lockdep_set_class_and_name(&(class)->mutex, &class_key,		\
+				 (class)->name);			\
+} while (0)
 #endif /* _DEVICE_H_ */
