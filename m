Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYLYNa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYLYNa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:30:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbYLYNat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:30:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:58822 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbYLYNas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:30:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Lf3epQ4uOCxJhCL90eeIKBAxK1Q6KyWFIP8gbIA7m7ngXpOTOW+6blMiRT/JTc34E8
         +ljJrT/ZOcEWhHSBiAReu/IHX9UwxS0YzHMvXCiYQv8DI18Tnk6yUaFmu6KBK8IcaYpD
         fhl+Bc/Cc/6RpSYQ5wW4r4xKRr3NE7peDAwn8=
Message-ID: <298610bb0812250530r4661cbfaof88ba9d3946e744f@mail.gmail.com>
Date: Thu, 25 Dec 2008 14:30:46 +0100
From: "=?UTF-8?Q?Krzysztof_Kosi=C5=84ski?=" <tweenk.pl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tc1100-wmi: fix state reporting
Cc: "Carlos Corbacho" <carlos@strangeworlds.co.uk>, linux-acpi@vger.kernel.org,
       "Len Brown" <lenb@kernel.org>
In-Reply-To: <200812250755.39288.carlos@strangeworlds.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <298610bb0812241845h41f5f916p73f85c64367ed8c@mail.gmail.com>
	 <200812250755.39288.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id mBPDV6ki021163

(Resend)This small patch fixes the state reported when reading the files in/sys/devices/platofrm/tc1100-wmi/*. The first change fixes alwaysreturning 0 from the files in sysfs. The second one fixes jogdialstate reporting to match with the commands used to set it (e.g. nowafter "echo 0 > /sys/devices/platofrm/tc1100-wmi/jogdial", "cat/sys/devices/platofrm/tc1100-wmi/jogdial" will return 0 instead of 1).Fixes bug #12286.
Signed-off-by: Krzysztof KosiÅ„ski <tweenk.pl@gmail.com>
--- linux-2.6.27/drivers/misc/tc1100-wmi.c      2008-10-1000:13:53.000000000 +0200+++ linux/drivers/misc/tc1100-wmi.c     2008-12-25 02:58:48.000000000 +0100@@ -95,9 +95,8 @@               return -ENODEV;
       obj = (union acpi_object *) result.pointer;-       if (obj && obj->type == ACPI_TYPE_BUFFER &&-               obj->buffer.length == sizeof(u32)) {-               tmp = *((u32 *) obj->buffer.pointer);+       if (obj && obj->type == ACPI_TYPE_INTEGER) {+               tmp = obj->integer.value;       } else {               tmp = 0;       }@@ -110,7 +109,7 @@               *out = (tmp == 3) ? 1 : 0;               return 0;       case TC1100_INSTANCE_JOGDIAL:-               *out = (tmp == 1) ? 1 : 0;+               *out = (tmp == 1) ? 0 : 1;               return 0;       default:               return -ENODEV;ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
