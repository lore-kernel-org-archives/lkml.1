Return-Path: <linux-kernel-owner+w=401wt.eu-S1760059AbZCNA2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760059AbZCNA2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZCNAS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:18:56 -0400
Received: from kroah.org ([198.145.64.141]:46958 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753176AbZCNASy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:18:54 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:44 2009
Message-Id: <20090314000744.116792352@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:05:42 -0700
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
       alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 34/96] cdc_ether: add usb id for Ericsson F3507g
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=cdc_ether-add-usb-id-for-ericsson-f3507g.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit cac477e8f1038c41b6f29d3161ce351462ef3df7 upstream.

The Ericsson F3507g wireless broadband module provides a CDC Ethernet
compliant interface, but identifies it as a "Mobile Direct Line" CDC
subclass, thereby preventing the CDC Ethernet class driver from picking
it up.  This patch adds the device id to cdc_ether.c as a workaround.

Ericsson has provided a "class" driver for this device:
http://kerneltrap.org/mailarchive/linux-net/2008/10/28/3832094
But closer inspection of that driver reveals that it adds little more
than duplication of code from cdc_ether.c.  See also
http://marc.info/?l=linux-usb&m=123334979706403&w=2

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/cdc_ether.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/usb/cdc_ether.c
+++ b/drivers/net/usb/cdc_ether.c
@@ -559,6 +559,11 @@ static const struct usb_device_id	produc
 	USB_INTERFACE_INFO(USB_CLASS_COMM, USB_CDC_SUBCLASS_ETHERNET,
 			USB_CDC_PROTO_NONE),
 	.driver_info = (unsigned long) &cdc_info,
+}, {
+	/* Ericsson F3507g */
+	USB_DEVICE_AND_INTERFACE_INFO(0x0bdb, 0x1900, USB_CLASS_COMM,
+			USB_CDC_SUBCLASS_MDLM, USB_CDC_PROTO_NONE),
+	.driver_info = (unsigned long) &cdc_info,
 },
 	{ },		// END
 };


