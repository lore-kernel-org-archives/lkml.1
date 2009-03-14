Return-Path: <linux-kernel-owner+w=401wt.eu-S1757631AbZCNAZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631AbZCNAZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZCNASo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:44 -0400
Received: from kroah.org ([198.145.64.141]:46812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752844AbZCNASl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:41 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:42 2009
Message-Id: <20090314000742.015741582@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dmitriy Taychenachev <dimichxp@gmail.com>
Subject: [patch 21/96] USB: cdc-acm: add usb id for motomagx phones
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=usb-cdc-acm-add-usb-id-for-motomagx-phones.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitriy Taychenachev <dimichxp@gmail.com>

commit 155df65ae11dfc322214c6f887185929c809df1b upstream.

The Motorola MOTOMAGX phones (Z6, E8, Zn5 so far) are providing
combined ACM/BLAN USB configuration. Since it has Vendor Specific
class, the corresponding drivers (cdc-acm, zaurus) can't find it just
by interface info. This patch adds usb id so the cdc-acm driver can
properly handle this combined device.

Signed-off-by: Dmitriy Taychenachev <dimichxp@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1365,6 +1365,8 @@ static struct usb_device_id acm_ids[] = 
 	{ USB_DEVICE(0x0572, 0x1321), /* Conexant USB MODEM CX93010 */
 	.driver_info = NO_UNION_NORMAL, /* has no union descriptor */
 	},
+	{ USB_DEVICE(0x22b8, 0x6425), /* Motorola MOTOMAGX phones */
+	},
 
 	/* control interfaces with various AT-command sets */
 	{ USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ACM,


