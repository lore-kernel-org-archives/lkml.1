Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588Ab0AIM5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab0AIM5E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 07:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241Ab0AIM5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 07:57:01 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:56210 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0AIM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 07:57:00 -0500
X-Authuid: nmarci
Message-ID: <4B487CF2.1060108@freemail.hu>
Date: Sat, 09 Jan 2010 13:56:18 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Markus Armbruster <armbru@redhat.com>,
       Anthony Liguori <aliguori@us.ibm.com>
CC: xen-devel@lists.xensource.com, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] input: make xenbus device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=8 Fuz1=8
	Fuz2=8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The ids field of the struct xenbus_device_id is constant in <linux/xen/xenbus.h>
so it is worth to make xenkbd_ids also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
--- a/drivers/input/xen-kbdfront.c 2010-01-07 19:08:40.000000000 +0100
+++ b/drivers/input/xen-kbdfront.c 2010-01-08 19:23:27.000000000 +0100
@@ -321,7 +321,7 @@ InitWait:
 	}
 }

-static struct xenbus_device_id xenkbd_ids[] = {
+static const struct xenbus_device_id xenkbd_ids[] = {
 	{ "vkbd" },
 	{ "" }
 };
