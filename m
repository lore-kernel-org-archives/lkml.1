Return-Path: <linux-kernel-owner+w=401wt.eu-S1762113AbZCNAou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762113AbZCNAou (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753502AbZCNATs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:48 -0400
Received: from kroah.org ([198.145.64.141]:34955 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753501AbZCNATg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:36 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:50 2009
Message-Id: <20090314000750.461326495@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:23 -0700
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
       alan@lxorguk.ukuu.org.uk, Dmitriy Taychenachev <dimichxp@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 75/96] zaurus: add usb id for motomagx phones
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=zaurus-add-usb-id-for-motomagx-phones.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dmitriy Taychenachev <dimichxp@gmail.com>

commit 52c0326beaa3cb0049d0f1c51c6ad5d4a04e4430 upstream.

The Motorola MOTOMAGX phones (Z6, E8, Zn5 so far) are providing
combined ACM/BLAN USB configuration. Since it has Vendor Specific
class, the corresponding drivers (cdc-acm, zaurus) can't find it just
by interface info. This patch adds usb id so the zaurus driver can
properly handle this combined device.

Signed-off-by: Dmitriy Taychenachev <dimichxp@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/zaurus.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/zaurus.c
+++ b/drivers/net/usb/zaurus.c
@@ -341,6 +341,11 @@ static const struct usb_device_id	produc
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_MDLM,
 			USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long) &bogus_mdlm_info,
+}, {
+	/* Motorola MOTOMAGX phones */
+	USB_DEVICE_AND_INTERFACE_INFO(0x22b8, 0x6425, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long) &bogus_mdlm_info,
 },
 
 /* Olympus has some models with a Zaurus-compatible option.


