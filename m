Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYGCWzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYGCWzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 18:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYGCWz2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 18:55:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:35299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756023AbYGCWz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 18:55:26 -0400
Subject: patch usb-fix-build-error-in-cdc-acm-for-config_pm-n.patch added to gregkh-2.6 tree
To: oliver@neukum.org, gregkh@suse.de, greg@kroah.com,
       linux-kernel@vger.kernel.org, oneukum@suse.de, randy.dunlap@oracle.com,
       sfr@canb.auug.org.au, stern@rowland.harvard.edu
From: <gregkh@suse.de>
Date: Thu, 03 Jul 2008 15:52:48 -0700
In-Reply-To: <200807011910.09251.oliver@neukum.org>
Message-ID: <12151255682099@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: fix build error in cdc-acm for CONFIG_PM=n

to my gregkh-2.6 tree.  Its filename is

     usb-fix-build-error-in-cdc-acm-for-config_pm-n.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From oliver@neukum.org  Thu Jul  3 15:36:51 2008
From: Oliver Neukum <oliver@neukum.org>
Date: Tue, 1 Jul 2008 19:10:08 +0200
Subject: USB: fix build error in cdc-acm for CONFIG_PM=n
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Alan Stern <stern@rowland.harvard.edu>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-ID: <200807011910.09251.oliver@neukum.org>
Content-Disposition: inline


Here's the fix. cdc-wdm has the same problem. The fix is the same.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/class/cdc-acm.c |    7 +++++++
 drivers/usb/class/cdc-wdm.c |    4 ++++
 2 files changed, 11 insertions(+)

--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -1255,6 +1255,7 @@ static void acm_disconnect(struct usb_in
 		tty_hangup(acm->tty);
 }
 
+#ifdef CONFIG_PM
 static int acm_suspend(struct usb_interface *intf, pm_message_t message)
 {
 	struct acm *acm = usb_get_intfdata(intf);
@@ -1320,6 +1321,8 @@ err_out:
 	mutex_unlock(&acm->mutex);
 	return rv;
 }
+
+#endif /* CONFIG_PM */
 /*
  * USB driver structure.
  */
@@ -1375,10 +1378,14 @@ static struct usb_driver acm_driver = {
 	.name =		"cdc_acm",
 	.probe =	acm_probe,
 	.disconnect =	acm_disconnect,
+#ifdef CONFIG_PM
 	.suspend =	acm_suspend,
 	.resume =	acm_resume,
+#endif
 	.id_table =	acm_ids,
+#ifdef CONFIG_PM
 	.supports_autosuspend = 1,
+#endif
 };
 
 /*
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -750,12 +750,16 @@ static int wdm_suspend(struct usb_interf
 	dev_dbg(&desc->intf->dev, "wdm%d_suspend\n", intf->minor);
 
 	mutex_lock(&desc->plock);
+#ifdef CONFIG_PM
 	if (interface_to_usbdev(desc->intf)->auto_pm && test_bit(WDM_IN_USE, &desc->flags)) {
 		rv = -EBUSY;
 	} else {
+#endif
 		cancel_work_sync(&desc->rxwork);
 		kill_urbs(desc);
+#ifdef CONFIG_PM
 	}
+#endif
 	mutex_unlock(&desc->plock);
 
 	return rv;


Patches currently in gregkh-2.6 which might be from oliver@neukum.org are

bad/ldp.next/usb-add-option-hso-driver.patch
usb/usb-fix-double-kfree-in-ipaq-in-error-case.patch
usb/usb-cdc-wdm-cleanup.patch
usb/usb-fix-build-error-in-cdc-acm-for-config_pm-n.patch
usb/usb-additional-power-savings-for-cdc-acm-devices-that-support-remote-wakeup.patch
usb/usb-autosuspend-for-cdc-wdm.patch
usb/usb-fix-disconnect-bug-in-cdc-acm.patch
usb/usb-fix-usb-serial-pm-counter-decrement-for-disconnected-interfaces.patch
usb.current/usb-fix-cdc-acm-resume.patch
usb.current/usb-adding-comment-for-ipaq-forcing-number-of-ports.patch
usb.current/usb-fix-oops-on-loading-ipaq-module-since-2.6.26.patch
