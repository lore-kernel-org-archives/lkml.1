Return-Path: <linux-kernel-owner+w=401wt.eu-S1757649AbZAMHvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbZAMHvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 02:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZAMHux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 02:50:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:44639 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZAMHuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 02:50:52 -0500
Subject: [PATCH -tip] nubus.h: extern's make no sense in userspace
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       sam@ravnborg.org, harvey.harrison@gmail.com, gorcunov@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 13:18:26 +0530
Message-Id: <1231832906.3212.24.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, Impact: fix 3 make headers_check warnings:

usr/include/linux/nubus.h:298: extern's make no sense in userspace
usr/include/linux/nubus.h:300: extern's make no sense in userspace
usr/include/linux/nubus.h:304: extern's make no sense in userspace

Also moved nubus_scan_bus() in __KERNEL__

Also removed obsolete get_nubus_list()

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 include/linux/nubus.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/nubus.h b/include/linux/nubus.h
index bd31554..9f54a23 100644
--- a/include/linux/nubus.h
+++ b/include/linux/nubus.h
@@ -297,6 +297,7 @@ struct nubus_dev {
 	struct nubus_board* board;
 };
 
+#ifdef __KERNEL__
 /* This is all NuBus devices (used to find devices later on) */
 extern struct nubus_dev* nubus_devices;
 /* This is all NuBus cards */
@@ -305,7 +306,7 @@ extern struct nubus_board* nubus_boards;
 /* Generic NuBus interface functions, modelled after the PCI interface */
 void nubus_scan_bus(void);
 extern void nubus_proc_init(void);
-int get_nubus_list(char *buf);
+#endif /* __KERNEL__ */
 int nubus_proc_attach_device(struct nubus_dev *dev);
 int nubus_proc_detach_device(struct nubus_dev *dev);
 /* If we need more precision we can add some more of these */
-- 
1.5.6.6



