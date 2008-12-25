Return-Path: <linux-kernel-owner+w=401wt.eu-S1752060AbYLYCpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060AbYLYCpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 21:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbYLYCp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 21:45:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:63995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLYCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 21:45:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=svFZPDr8lHl3wpugTcCN3+1D/5RYB6ARYkLz63o/ajWXlGbpnUqQr6Ionoh8iZg8JI
         QnSxWTMgr8/Pxw1rCn029R+vXNhrxsdkEiNpMFrVdduQLVAmo8gRCja/DB65wwuq+2Oe
         N6v9QCGYXOqpbXIDTN9qTkNP9v8AFbFhatWPE=
Message-ID: <298610bb0812241845h41f5f916p73f85c64367ed8c@mail.gmail.com>
Date: Thu, 25 Dec 2008 03:45:25 +0100
From: "=?UTF-8?Q?Krzysztof_Kosi=C5=84ski?=" <tweenk.pl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tc1100-wmi: fix state reporting
Cc: carlos@strangeworlds.co.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBP2jfki017189

This small patch fixes the state reported when reading the files in/sys/devices/platofrm/tc1100-wmi/*. The first change fixes alwaysreturning 0 from the files in sysfs. The second one fixes jogdialstate reprting to match with the commands used to set it (e.g. nowafter "echo 0 > /sys/devices/platofrm/tc1100-wmi/jogdial", "cat/sys/devices/platofrm/tc1100-wmi/jogdial" will return 0 instead of 1).
Please CC any replies to me (I'm not subscribed).Regards, Krzysztof KosiÅ„ski
--- linux-2.6.27/drivers/misc/tc1100-wmi.c	2008-10-10 00:13:53.000000000 +0200+++ linux/drivers/misc/tc1100-wmi.c	2008-12-25 02:58:48.000000000 +0100@@ -95,9 +95,8 @@ 		return -ENODEV;
 	obj = (union acpi_object *) result.pointer;-	if (obj && obj->type == ACPI_TYPE_BUFFER &&-		obj->buffer.length == sizeof(u32)) {-		tmp = *((u32 *) obj->buffer.pointer);+	if (obj && obj->type == ACPI_TYPE_INTEGER) {+		tmp = obj->integer.value; 	} else { 		tmp = 0; 	}@@ -110,7 +109,7 @@ 		*out = (tmp == 3) ? 1 : 0; 		return 0; 	case TC1100_INSTANCE_JOGDIAL:-		*out = (tmp == 1) ? 1 : 0;+		*out = (tmp == 1) ? 0 : 1; 		return 0; 	default: 		return -ENODEV;ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
