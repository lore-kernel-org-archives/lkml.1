Return-Path: <linux-kernel-owner+w=401wt.eu-S1758621AbYHUKd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621AbYHUKd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYHUKdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:33:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57518 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503AbYHUKdR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:33:17 -0400
Message-ID: <48AD4414.6080604@jp.fujitsu.com>
Date: Thu, 21 Aug 2008 19:31:48 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix possible kobject reference counter leak in kobject_rename()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I found a possible kobject reference counter leak problem in
kobject_rename(). The following patch will fix it.

Thanks,
Kenji Kaneshige


Fix possible kobject reference counter leak in kobject_rename().

If kobject_rename() failed because of name collision, we must call
kobject_put() for specified kobject before return.

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

---
 lib/kobject.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.27-rc4/lib/kobject.c
===================================================================
--- linux-2.6.27-rc4.orig/lib/kobject.c
+++ linux-2.6.27-rc4/lib/kobject.c
@@ -411,6 +411,7 @@ int kobject_rename(struct kobject *kobj,
 			       "to '%s' as '%s' is already in existence.\n",
 			       kobject_name(kobj), new_name, new_name);
 			kobject_put(temp_kobj);
+			kobject_put(kobj);
 			return -EINVAL;
 		}
 	}

