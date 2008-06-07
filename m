Return-Path: <linux-kernel-owner+w=401wt.eu-S1759155AbYFGBKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759155AbYFGBKw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759466AbYFGBIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:08:49 -0400
Received: from sous-sol.org ([216.99.217.87]:42265 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760579AbYFGBIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:08:48 -0400
Message-Id: <20080607010551.736483245@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:21 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Iain McFarlane <iain@imcfarla.homelinux.net>,
       Oliver Neukum <oneukum@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/50] USB: add Zoom Telephonics Model 3095F V.92 USB Mini External modem to cdc-acm
Content-Disposition: inline; filename=usb-add-zoom-telephonics-model-3095f-v.92-usb-mini-external-modem-to-cdc-acm.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Iain McFarlane <iain@imcfarla.homelinux.net>

commit 6149ed5e3a6207595bd7362af7724d64f44af216 upstream

The patch below is a necessary workaround to support the Zoom Telephonics Model 3095F V.92 USB Mini External modem, which fails to initialise properly during normal probing thus:

May  3 22:53:00 imcfarla kernel: drivers/usb/class/cdc-acm.c: Zero length descriptor references
May  3 22:53:00 imcfarla kernel: cdc_acm: probe of 5-2:1.0 failed with error -22

Adding the patch below causes the probing section to be skipped, and the modem
then initialises correctly.

Signed-off-by: Iain McFarlane <iain@imcfarla.homelinux.net>
Acked-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/usb/class/cdc-acm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1242,6 +1242,9 @@ static struct usb_device_id acm_ids[] = 
 	{ USB_DEVICE(0x22b8, 0x7000), /* Motorola Q Phone */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x0803, 0x3095), /* Zoom Telephonics Model 3095F USB MODEM */
+	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
+	},
 
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,

-- 
