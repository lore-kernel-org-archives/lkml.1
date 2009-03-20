Return-Path: <linux-kernel-owner+w=401wt.eu-S1764123AbZCTXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764123AbZCTXhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763016AbZCTXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 19:24:50 -0400
Received: from kroah.org ([198.145.64.141]:48764 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762564AbZCTXYt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 19:24:49 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 20 15:29:28 2009
Message-Id: <20090320222927.951096921@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 20 Mar 2009 15:28:42 -0700
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
       alan@lxorguk.ukuu.org.uk
Subject: [patch 32/43] USB: usbtmc: fix stupid bug in open()
References: <20090320222810.386844059@mini.kroah.org>
Content-Disposition: inline; filename=usb-usbtmc-fix-stupid-bug-in-open.patch
In-Reply-To: <20090320232116.GA3375@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Greg Kroah-Hartman <gregkh@suse.de>

commit 5b10916ea0a62920204517e1c4ce14560b4f96ab upstream.

open() will never succeed, as we always return -ENODEV.  Fix this
obvious bug.

Thanks to Jouni Ryno for reporting it.

Reported-by: Jouni Ryno <Jouni.Ryno@fmi.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/usbtmc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -105,12 +105,13 @@ static int usbtmc_open(struct inode *ino
 {
 	struct usb_interface *intf;
 	struct usbtmc_device_data *data;
-	int retval = -ENODEV;
+	int retval = 0;
 
 	intf = usb_find_interface(&usbtmc_driver, iminor(inode));
 	if (!intf) {
 		printk(KERN_ERR KBUILD_MODNAME
 		       ": can not find device for minor %d", iminor(inode));
+		retval = -ENODEV;
 		goto exit;
 	}
 


