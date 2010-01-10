Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080Ab0AJMNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab0AJMNl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 07:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010Ab0AJMNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 07:13:40 -0500
Received: from mail02d.mail.t-online.hu ([84.2.42.7]:58613 "EHLO
	mail02d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0AJMNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 07:13:39 -0500
Message-ID: <4B49C46F.3080901@freemail.hu>
Date: Sun, 10 Jan 2010 13:13:35 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH 2/2] 1-wire: make USB device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail02d.mail.t-online.hu 32721; Body=4 Fuz1=4
	Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The id_table field of the struct usb_device_id is constant in <linux/usb.h>
so it is worth to make ds_id_table also constant.

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
diff -u -p a/drivers/w1/masters/ds2490.c b/drivers/w1/masters/ds2490.c
--- a/drivers/w1/masters/ds2490.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/w1/masters/ds2490.c 2010-01-08 07:52:31.000000000 +0100
@@ -170,7 +170,7 @@ struct ds_status

 };

-static struct usb_device_id ds_id_table [] = {
+static const struct usb_device_id ds_id_table[] = {
 	{ USB_DEVICE(0x04fa, 0x2490) },
 	{ },
 };
