Return-Path: <linux-kernel-owner+w=401wt.eu-S1760083AbXJ2SXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbXJ2SXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 14:23:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXJ2SXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 14:23:32 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:22034 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895AbXJ2SXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 14:23:31 -0400
Date: Mon, 29 Oct 2007 11:19:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
       akpm <akpm@linux-foundation.org>
Subject: [PATCH] media/video: ir-functions use input functions, should
 depend on INPUT
Message-Id: <20071029111950.0e8bd432.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Media ir-functions uses input_(*) functions so it should depend
on the INPUT config symbol.

drivers/built-in.o: In function `ir_input_key_event':
ir-functions.c:(.text+0x10849a): undefined reference to `input_event'
ir-functions.c:(.text+0x1084ac): undefined reference to `input_event'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-2624-rc1g4-v1.orig/drivers/media/Kconfig
+++ linux-2624-rc1g4-v1/drivers/media/Kconfig
@@ -151,6 +151,7 @@ config VIDEO_IR_I2C
 
 config VIDEO_IR
 	tristate
+	depends on INPUT
 	select VIDEO_IR_I2C if I2C
 
 config VIDEO_TVEEPROM
