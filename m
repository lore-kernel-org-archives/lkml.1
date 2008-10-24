Return-Path: <linux-kernel-owner+w=401wt.eu-S1755007AbYJXEmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007AbYJXEmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 00:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYJXEjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 00:39:14 -0400
Received: from kroah.org ([198.145.64.141]:51702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751961AbYJXEjK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 00:39:10 -0400
Date: Thu, 23 Oct 2008 21:34:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>
Subject: [patch 08/27] USB: Speedtouch: add pre_reset and post_reset
	routines
Message-ID: <20081024043405.GI30828@kroah.com>
References: <20081024042023.054190751@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-speedtouch-add-pre_reset-and-post_reset-routines.patch"
In-Reply-To: <20081024043303.GA30828@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us 
know.

------------------
From: Alan Stern <stern@rowland.harvard.edu>

commit 8fc7aeab3851ed8c3ecf28901ca2c6f0400955c7 upstream

This patch (as1150) fixes a problem in the speedtch driver.  When it
resets the modem during probe it will be unbound from the other
interfaces it has claimed, because it doesn't define a pre_reset and a
post_reset method.

The patch defines "do-nothing" methods.  This fixes Bugzilla #11767.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/atm/speedtch.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/usb/atm/speedtch.c
+++ b/drivers/usb/atm/speedtch.c
@@ -722,6 +722,16 @@ static void speedtch_atm_stop(struct usb
 	flush_scheduled_work();
 }
 
+static int speedtch_pre_reset(struct usb_interface *intf)
+{
+	return 0;
+}
+
+static int speedtch_post_reset(struct usb_interface *intf)
+{
+	return 0;
+}
+
 
 /**********
 **  USB  **
@@ -740,6 +750,8 @@ static struct usb_driver speedtch_usb_dr
 	.name		= speedtch_driver_name,
 	.probe		= speedtch_usb_probe,
 	.disconnect	= usbatm_usb_disconnect,
+	.pre_reset	= speedtch_pre_reset,
+	.post_reset	= speedtch_post_reset,
 	.id_table	= speedtch_usb_ids
 };
 

-- 
