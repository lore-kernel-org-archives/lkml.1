Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214Ab0A3Sju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0A3Sju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181Ab0A3Sjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:39:47 -0500
Received: from kolab.mylinuxtime.de ([80.190.48.10]:52844 "EHLO
	kolab.mylinuxtime.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754045Ab0A3Sjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:39:43 -0500
X-Spam-ASN: 
From: Christian Hesse <mail@earthworm.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: Samsung N220 backlight support
Date: Sat, 30 Jan 2010 19:37:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-ARCH; KDE/4.3.4; x86_64; ; )
References: <201001301706.18245.mail@earthworm.de> <20100130162857.GA26029@suse.de>
In-Reply-To: <20100130162857.GA26029@suse.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_uxHZLzbE2NvlT/d"
Message-Id: <201001301937.34834.mail@earthworm.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_uxHZLzbE2NvlT/d
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Saturday 30 January 2010 17:28:57 you wrote:
> On Sat, Jan 30, 2010 at 05:06:18PM +0100, Christian Hesse wrote:
> > Hello Greg,
> >
> > this adds support for Samsung N220 to your samsung-backlight. Tested on
> > my device, works for me.
> 
> Hm, the driver that ended up in the kernel is very different from this
> version.  Can you work with that version and add the needed changes
> there and generate a patch?

Oh, did not notice it was included in mainline already.
I applied the attached patch. Insmod now gives:

insmod: error inserting 'samsung-laptop.ko': -1 Invalid parameters

and the logs contain the following:

kernel: samsung_laptop: found laptop model 'N220'
kernel: This computer does not support SABI

What is this SABI and SECLINUX thing about? Do you have a link to any more 
information? Is it possible that the N220 does not have this?
The N220 uses a Pine Train platform (featuring N450 with 64bit support), so I 
installed x86_64 to the device.

I would be glad to test whatever you give me.

Regards,
Chris

--Boundary-00=_uxHZLzbE2NvlT/d
Content-Type: text/x-patch;
  charset="UTF-8";
  name="samsung-laptop-n220.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="samsung-laptop-n220.diff"

--- linux-2.6.33-rc6/drivers/staging/samsung-laptop/samsung-laptop.c	2010-01-30 17:40:18.000000000 +0100
+++ linux-2.6.33-rc6/drivers/staging/samsung-laptop/samsung-laptop.c	2010-01-30 18:27:06.000000000 +0100
@@ -385,6 +385,15 @@ static struct dmi_system_id __initdata s
 		},
 		.callback = dmi_check_cb,
 	},
+	{
+		.ident = "N220",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "N220"),
+			DMI_MATCH(DMI_BOARD_NAME, "N220"),
+		},
+		.callback = dmi_check_cb,
+	},
 	{ },
 };
 MODULE_DEVICE_TABLE(dmi, samsung_dmi_table);

--Boundary-00=_uxHZLzbE2NvlT/d--
