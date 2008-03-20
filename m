Return-Path: <linux-kernel-owner+w=401wt.eu-S1759849AbYCTXYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759849AbYCTXYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758231AbYCTXYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:24:18 -0400
Received: from ns1.suse.de ([195.135.220.2]:45768 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757917AbYCTXYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:24:16 -0400
Subject: patch pm-fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch added to gregkh-2.6 tree
To: stern@rowland.harvard.edu, akpm@linux-foundation.org, greg@kroah.com,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, rjw@sisk.pl
From: <gregkh@suse.de>
Date: Thu, 20 Mar 2008 16:23:48 -0700
In-Reply-To: <200803192235.14645.rjw@sisk.pl>
Message-ID: <120605542858@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: PM: Fix misuse of wakeup flag accessors in serial core

to my gregkh-2.6 tree.  Its filename is

     pm-fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From rjw@sisk.pl  Thu Mar 20 16:20:16 2008
From: Alan Stern <stern@rowland.harvard.edu>
Date: Wed, 19 Mar 2008 22:35:13 +0100
Subject: PM: Fix misuse of wakeup flag accessors in serial core
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alan Stern <stern@rowland.harvard.edu>, Linux-pm mailing list <linux-pm@lists.linux-foundation.org>, Kernel development list <linux-kernel@vger.kernel.org>, lenb@kernel.org
Message-ID: <200803192235.14645.rjw@sisk.pl>
Content-Disposition: inline


From: Alan Stern <stern@rowland.harvard.edu>

This patch (as1059) fixes a mistake in the way the serial core
initializes a device's wakeup settings.  It should use the accessor
routine instead of relying on a macro producing an lvalue.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/serial/serial_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2356,7 +2356,7 @@ int uart_add_one_port(struct uart_driver
 	 */
 	tty_dev = tty_register_device(drv->tty_driver, port->line, port->dev);
 	if (likely(!IS_ERR(tty_dev))) {
-		device_can_wakeup(tty_dev) = 1;
+		device_init_wakeup(tty_dev, 1);
 		device_set_wakeup_enable(tty_dev, 0);
 	} else
 		printk(KERN_ERR "Cannot register tty device on line %d\n",


Patches currently in gregkh-2.6 which might be from stern@rowland.harvard.edu are

usb/usb-convert-usb.h-struct-usb_device-to-kernel-doc.patch
usb/usb-make-usb_storage_onetouch-available-with-pm.patch
usb/usb-usb-ohci-sm501-driver-use-the-conventional-convention-for-suspend-and-resume.patch
usb/usb-reorganize-code-in-hub.c.patch
usb/usb-ehci-carry-out-port-handover-during-each-root-hub-resume.patch
usb/usb-new-quirk-flag-to-avoid-set-interface.patch
usb/drivers-usb-core-devio.c-suppress-warning-with-64k-page_size.patch
usb/usb-make-usb-persist-work-after-every-system-sleep.patch
usb/usb-remove-config_usb_persist-setting.patch
usb/usb-check-serial-number-string-after-device-reset.patch
usb/usb-enable-usb-persist-by-default.patch
usb/usb-remove-dev-power.power_state.patch
usb/usb-isd200-fix-memory-leak-in-isd200_get_inquiry_data.patch
usb/usb-remove-experimental-tags-from-some-usb-gadget-kconfig-entries.patch
driver-core/pm-handle-device-registrations-during-suspend-resume.patch
driver-core/pm-convert-wakeup-flag-accessors-to-inline-functions.patch
driver-core/driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
driver-core/pm-fix-misuse-of-wakeup-flag-accessors-in-serial-core.patch
driver-core/pm-make-wakeup-flags-available-whenever-config_pm-is-set.patch
