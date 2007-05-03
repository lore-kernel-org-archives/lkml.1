Return-Path: <linux-kernel-owner+w=401wt.eu-S1030180AbXECVe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030180AbXECVe4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031288AbXECVe4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:34:56 -0400
Received: from mx33.mail.ru ([194.67.23.194]:2269 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030180AbXECVew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:34:52 -0400
Date: Fri, 4 May 2007 01:31:21 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/8] remove "#if 0" from find_bus function, export it.
Message-ID: <20070503213121.GA20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This function were placed in "#if 0" because nobody was using it.
We using it now.

See http://lwn.net/Articles/210610/

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/base/bus.c     |    5 ++---
 include/linux/device.h |    2 ++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 253868e..971efa2 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -667,14 +667,13 @@ void put_bus(struct bus_type * bus)
  *
  *	Note that kset_find_obj increments bus' reference count.
  */
-#if 0
+
 struct bus_type * find_bus(char * name)
 {
 	struct kobject * k = kset_find_obj(&bus_subsys.kset, name);
 	return k ? to_bus(k) : NULL;
 }
-#endif  /*  0  */
-
+EXPORT_SYMBOL_GPL(find_bus);
 
 /**
  *	bus_add_attrs - Add default attributes for this bus.
diff --git a/include/linux/device.h b/include/linux/device.h
index 5cf30e9..4015b39 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -68,6 +68,8 @@ extern void bus_unregister(struct bus_type * bus);
 
 extern int __must_check bus_rescan_devices(struct bus_type * bus);
 
+extern struct bus_type *find_bus(char *name);
+
 /* iterator helpers for buses */
 
 int bus_for_each_dev(struct bus_type * bus, struct device * start, void * data,
-- 
1.5.1.1-dirty

