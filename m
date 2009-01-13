Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbZAMB3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbZAMB3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:29:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbZAMB2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:28:55 -0500
Received: from kroah.org ([198.145.64.141]:35878 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757041AbZAMB2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:54 -0500
Date: Mon, 12 Jan 2009 17:26:49 -0800
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
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 01/21] USB: gadget: fix rndis working at high speed
Message-ID: <20090113012649.GB4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-gadget-fix-rndis-working-at-high-speed.patch"
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David Brownell <dbrownell@users.sourceforge.net>

commit 7c12414955e9b44a3e33d54e578bf008caa4475d upstream.

Fix a bug specific to highspeed mode in the recently updated RNDIS
support:  it wasn't setting up the high speed notification endpoint,
which prevented high speed RNDIS links from working.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Tested-by: Anand Gadiyar <gadiyar@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_rndis.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/f_rndis.c
+++ b/drivers/usb/gadget/f_rndis.c
@@ -651,6 +651,8 @@ rndis_bind(struct usb_configuration *c, 
 				fs_in_desc.bEndpointAddress;
 		hs_out_desc.bEndpointAddress =
 				fs_out_desc.bEndpointAddress;
+		hs_notify_desc.bEndpointAddress =
+				fs_notify_desc.bEndpointAddress;
 
 		/* copy descriptors, and track endpoint copies */
 		f->hs_descriptors = usb_copy_descriptors(eth_hs_function);
@@ -662,6 +664,8 @@ rndis_bind(struct usb_configuration *c, 
 				f->hs_descriptors, &hs_in_desc);
 		rndis->hs.out = usb_find_endpoint(eth_hs_function,
 				f->hs_descriptors, &hs_out_desc);
+		rndis->hs.notify = usb_find_endpoint(eth_hs_function,
+				f->hs_descriptors, &hs_notify_desc);
 	}
 
 	rndis->port.open = rndis_open;

