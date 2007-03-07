Return-Path: <linux-kernel-owner+w=401wt.eu-S1422803AbXCGROv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422803AbXCGROv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 12:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422800AbXCGROq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 12:14:46 -0500
Received: from ns1.suse.de ([195.135.220.2]:43639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422785AbXCGRO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 12:14:28 -0500
Message-Id: <20070307171240.944155031@mini.kroah.org>
References: <20070307171035.150802805@mini.kroah.org>
User-Agent: quilt/0.45-1
Date: Wed, 07 Mar 2007 09:11:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, len.brown@intel.com, cappaberra@gmail.com,
       Michael Hanselmann <linux-kernel@hansmi.ch>
Subject: [patch 025/101] Fix null pointer dereference in appledisplay driver
Content-Disposition: inline; filename=fix-null-pointer-dereference-in-appledisplay-driver.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hanselmann <linux-kernel@hansmi.ch>

Commit 40b20c257a13c5a526ac540bc5e43d0fdf29792a by Len Brown introduced
a null pointer dereference in the appledisplay driver. This patch fixes
it.

Signed-off-by: Michael Hanselmann <linux-kernel@hansmi.ch>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/usb/misc/appledisplay.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.20.1.orig/drivers/usb/misc/appledisplay.c
+++ linux-2.6.20.1/drivers/usb/misc/appledisplay.c
@@ -281,8 +281,8 @@ static int appledisplay_probe(struct usb
 	/* Register backlight device */
 	snprintf(bl_name, sizeof(bl_name), "appledisplay%d",
 		atomic_inc_return(&count_displays) - 1);
-	pdata->bd = backlight_device_register(bl_name, NULL, NULL,
-						&appledisplay_bl_data);
+	pdata->bd = backlight_device_register(bl_name, NULL,
+		pdata, &appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
 		err("appledisplay: Backlight registration failed");
 		goto error;

--
