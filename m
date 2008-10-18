Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823AbYJRTHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbYJRTHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 15:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYJRTDZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 15:03:25 -0400
Received: from mail.suse.de ([195.135.220.2]:38169 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbYJRTDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 15:03:23 -0400
Date: Sat, 18 Oct 2008 11:34:21 -0700
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
       alan@lxorguk.ukuu.org.uk, Yauhen Kharuzhy <jekhor@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: [patch 11/17] USB: Fix s3c2410_udc usb speed handling
Message-ID: <20081018183421.GL14035@suse.de>
References: <20081018182721.521723254@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="usb-fix-s3c2410_udc-usb-speed-handling.patch"
In-Reply-To: <20081018183334.GA14035@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Yauhen Kharuzhy <jekhor@gmail.com>

commit f9e9cff613b8239ce9159735aa662c9c85b478bf upstream

The new composite framework revealed a weakness in the
s3c2410_udc driver gadget register function. Instead of
checking if speed asked for was USB_LOW_SPEED upon
usb_gadget_register() to deny service, it checked only
for USB_FULL_SPEED, thus denying service to usb high
speed capable gadgets (like g_ether).

Signed-off-by: Yauhen Kharuzhy <jekhor@gmail.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/s3c2410_udc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/s3c2410_udc.c
+++ b/drivers/usb/gadget/s3c2410_udc.c
@@ -1651,7 +1651,7 @@ int usb_gadget_register_driver(struct us
 		return -EBUSY;
 
 	if (!driver->bind || !driver->setup
-			|| driver->speed != USB_SPEED_FULL) {
+			|| driver->speed < USB_SPEED_FULL) {
 		printk(KERN_ERR "Invalid driver: bind %p setup %p speed %d\n",
 			driver->bind, driver->setup, driver->speed);
 		return -EINVAL;

-- 
