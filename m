Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbZKFWLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbZKFWLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759936AbZKFWLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:11:36 -0500
Received: from kroah.org ([198.145.64.141]:39735 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759918AbZKFWFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:05:46 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 13:59:51 2009
Message-Id: <20091106215951.081519349@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 13:56:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [08/30] Input: synaptics - add another Protege M300 to rate blacklist
References: <20091106215603.413650799@mini.kroah.org>
Content-Disposition: inline; filename=input-synaptics-add-another-protege-m300-to-rate-blacklist.patch
In-Reply-To: <20091106220156.GA13813@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

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
@@ -623,6 +623,16 @@ static const struct dmi_system_id toshib
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


