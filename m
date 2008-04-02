Return-Path: <linux-kernel-owner+w=401wt.eu-S1760986AbYDBUvn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760986AbYDBUvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 16:51:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756659AbYDBUvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 16:51:36 -0400
Received: from ns2.suse.de ([195.135.220.15]:41771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754928AbYDBUvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 16:51:35 -0400
Subject: patch usb-another-ehci_iaa_watchdog-fix.patch added to gregkh-2.6 tree
To: david-b@pacbell.net, akpm@linux-foundation.org,
       dbrownell@users.sourceforge.net, greg@kroah.com, gregkh@suse.de,
       linux-kernel@vger.kernel.org, lkml@rtr.ca, mlord@pobox.com
From: <gregkh@suse.de>
Date: Wed, 02 Apr 2008 13:51:29 -0700
In-Reply-To: <200804021340.21348.david-b@pacbell.net>
Message-ID: <12071694892986@kroah.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

     Subject: USB: another ehci_iaa_watchdog fix

to my gregkh-2.6 tree.  Its filename is

     usb-another-ehci_iaa_watchdog-fix.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From david-b@pacbell.net  Wed Apr  2 13:49:39 2008
From: David Brownell <david-b@pacbell.net>
Date: Wed, 2 Apr 2008 13:40:20 -0700
Subject: USB: another ehci_iaa_watchdog fix
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, Mark Lord <lkml@rtr.ca>
Message-ID: <200804021340.21348.david-b@pacbell.net>
Content-Disposition: inline


This patch, suggested by Alan Stern, fixes the hung USB issues
on my notebook from suspend/resume cycles.

It does so by eliminating some confusion about the internal state
machine associated with unlinking from the EHCI async schedule ring,
which caused a recent regression:

  http://bugzilla.kernel.org/show_bug.cgi?id=10345

Signed-off-by: Mark Lord <mlord@pobox.com>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-hub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -126,8 +126,6 @@ static int ehci_bus_suspend (struct usb_
 		hcd->state = HC_STATE_QUIESCING;
 	}
 	ehci->command = ehci_readl(ehci, &ehci->regs->command);
-	if (ehci->reclaim)
-		end_unlink_async(ehci);
 	ehci_work(ehci);
 
 	/* Unlike other USB host controller types, EHCI doesn't have
@@ -171,6 +169,9 @@ static int ehci_bus_suspend (struct usb_
 	ehci_halt (ehci);
 	hcd->state = HC_STATE_SUSPENDED;
 
+	if (ehci->reclaim)
+		end_unlink_async(ehci);
+
 	/* allow remote wakeup */
 	mask = INTR_MASK;
 	if (!device_may_wakeup(&hcd->self.root_hub->dev))


Patches currently in gregkh-2.6 which might be from david-b@pacbell.net are

usb/usb-ehci-minor-cleanups.patch
usb/usb-defines-for-usb-link-power-management-ecn.patch
usb/usb-ehci-minor-soc-bus-glue-fixes.patch
usb/usb-ehci-refactor-if-state-hc_state_halt.patch
usb/usb-ehci-tolerates-some-buggy-devices.patch
usb/usb-ohci-port-reset-paranoia-timeout.patch
usb/usb-ehci-paranoia-reject-large-control-transfers.patch
usb/usb-g_printer-bugfixes.patch
usb/usb-ehci-remove-obsolete-workaround-for-bogus-irqs.patch
usb/usb-minor-ehci-xitd-simplifications.patch
usb/usb-remove-dev-power.power_state.patch
usb/usb-partial-usb-embedded-host-support.patch
usb/usb-fix-bug-in-sg-initialization-in-usbtest.patch
usb/usb-another-ehci_iaa_watchdog-fix.patch
usb/usb-remove-experimental-tags-from-some-usb-gadget-kconfig-entries.patch
usb/usb-gadget-dummy_hcd.c-fix-nested-switch-statements.patch
usb/usb-ohci-fix-2-timers-to-fire-at-jiffies-1s.patch
driver-core/pm-handle-device-registrations-during-suspend-resume.patch
driver-core/driver-core-call-device_pm_add-after-bus_add_device-in-device_add.patch
