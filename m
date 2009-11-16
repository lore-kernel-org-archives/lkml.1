Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbZKPETP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbZKPETP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:19:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbZKPETJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:19:09 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56872 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbZKPETH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:19:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vaNi8AytkdCQ0jEoWR3MsIIgM6Lf+4XiI7ivxR47PptniAlwUpaaodvZbH6fYJz18+
         PAnu8nGGelRgJuTj8102YDO3VGJYoxSh/dDUipye8TzsFUcqg8ndw86GnI8vLGtHI60I
         Qo2jUCflp0Kt4vFmSUAXHIayp8sMKSVC5u2+M=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 11/13] staging: line6: Convert simple_strtoul to strict_strtoul in variax.c
Date: Sun, 15 Nov 2009 22:18:00 -0600
Message-Id: <1258345082-11811-12-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/variax.c |   31 ++++++++++++++++++++++++++-----
 1 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/line6/variax.c b/drivers/staging/line6/variax.c
index f9d9698..48d834b 100644
--- a/drivers/staging/line6/variax.c
+++ b/drivers/staging/line6/variax.c
@@ -184,7 +184,12 @@ static ssize_t variax_set_volume(struct device *dev,
 				 const char *buf, size_t count)
 {
 	struct usb_line6_variax *variax = usb_get_intfdata(to_usb_interface(dev));
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
 
 	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_volume,
 				     value) == 0)
@@ -211,7 +216,12 @@ static ssize_t variax_set_model(struct device *dev,
 				const char *buf, size_t count)
 {
 	struct usb_line6_variax *variax = usb_get_intfdata(to_usb_interface(dev));
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
 
 	if (line6_send_program(&variax->line6, value) == 0)
 		variax->model = value;
@@ -237,8 +247,14 @@ static ssize_t variax_set_active(struct device *dev,
 				 const char *buf, size_t count)
 {
 	struct usb_line6_variax *variax = usb_get_intfdata(to_usb_interface(dev));
-	int value = simple_strtoul(buf, NULL, 10) ? 1 : 0;
-	variax->buffer_activate[VARIAX_OFFSET_ACTIVATE] = value;
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
+	variax->buffer_activate[VARIAX_OFFSET_ACTIVATE] = value ? 1: 0;
 	line6_send_raw_message_async(&variax->line6, variax->buffer_activate,
 				     sizeof(variax_activate));
 	return count;
@@ -262,7 +278,12 @@ static ssize_t variax_set_tone(struct device *dev,
 			       const char *buf, size_t count)
 {
 	struct usb_line6_variax *variax = usb_get_intfdata(to_usb_interface(dev));
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
 
 	if (line6_transmit_parameter(&variax->line6, VARIAXMIDI_tone,
 				     value) == 0)
-- 
1.6.5

