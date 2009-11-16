Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZKPETi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZKPETi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 23:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753154AbZKPETh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 23:19:37 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:64232 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbZKPETP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 23:19:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tCm1NczzOfr3XEcRsUhFefo3xz7F9HgJTcpqRRe4lP8on474FiRDkhN7rRf+thO9vI
         Db8rHOs/HM5mtD9TwrqN77u7RaOkRlqldCwzhvu6KyXS/+pg6RtC8AJW9Mni3Lj8wEIL
         8WU5epx1u7D3bbdNrmimCoW0C2lHFgPgBoHDA=
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Shawn Bohrer <shawn.bohrer@gmail.com>
Subject: [PATCH 13/13] staging: line6: Convert simple_strtoul to strict_strtoul in midi.c
Date: Sun, 15 Nov 2009 22:18:02 -0600
Message-Id: <1258345082-11811-14-git-send-email-shawn.bohrer@gmail.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
References: <1258345082-11811-1-git-send-email-shawn.bohrer@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Shawn Bohrer <shawn.bohrer@gmail.com>
---
 drivers/staging/line6/midi.c |   16 ++++++++++++++--
 1 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/line6/midi.c b/drivers/staging/line6/midi.c
index 89a2b17..6ef4455 100644
--- a/drivers/staging/line6/midi.c
+++ b/drivers/staging/line6/midi.c
@@ -318,7 +318,13 @@ static ssize_t midi_set_midi_mask_transmit(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
 	line6->line6midi->midi_mask_transmit = value;
 	return count;
 }
@@ -344,7 +350,13 @@ static ssize_t midi_set_midi_mask_receive(struct device *dev,
 {
 	struct usb_interface *interface = to_usb_interface(dev);
 	struct usb_line6 *line6 = usb_get_intfdata(interface);
-	int value = simple_strtoul(buf, NULL, 10);
+	unsigned long value;
+	int ret;
+
+	ret = strict_strtoul(buf, 10, &value);
+	if (ret)
+		return ret;
+
 	line6->line6midi->midi_mask_receive = value;
 	return count;
 }
-- 
1.6.5

