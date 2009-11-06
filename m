Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbZKFWqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbZKFWqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933167AbZKFWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:46:16 -0500
Received: from kroah.org ([198.145.64.141]:56713 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760111AbZKFWWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:22:32 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:41 2009
Message-Id: <20091106221540.929583902@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [17/99] Input: synaptics - add another Protege M300 to rate blacklist
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=input-synaptics-add-another-protege-m300-to-rate-blacklist.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 5f5eeff4c93256ee93435a3bf08cf18c45e9a994 upstream.

Apparently some of Toshiba Protege M300 identify themselves as
"Portable PC" in DMI so we need to add that to the DMI table as
well. We need DMI data so we can automatically lower Synaptics
reporting rate from 80 to 40 pps to avoid over-taxing their
keyboard controllers.

Tested-by: Rod Davison <roddavison@gmail.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/synaptics.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -652,6 +652,16 @@ static const struct dmi_system_id toshib
 			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "PORTEGE M300"),
 		},
+
+	},
+	{
+		.ident = "Toshiba Portege M300",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Portable PC"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Version 1.0"),
+		},
+
 	},
 	{ }
 };


