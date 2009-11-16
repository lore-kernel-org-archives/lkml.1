Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbZKPLW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbZKPLW4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 06:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbZKPLWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 06:22:55 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52453 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZKPLWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 06:22:55 -0500
Date: Mon, 16 Nov 2009 12:22:54 +0100
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: -rc6: something (probably active usb bluetooth) blocks suspend
Message-ID: <20091116112254.GB12315@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux amd 2.6.32-rc6-00498-g05b553a-dirty #89 SMP Fri Nov 13 10:43:31
CET 2009 i686 GNU/Linux

...and yes, it is a regression. Hw is thinkpad x60.

Tried to suspend, machine came right back, used radio kill switch, and
it suspended ok. Relevant messages seem to be:

								Pavel

PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.02 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
usb 5-2: usb suspend
btusb_intr_complete: hci0 urb f3b57420 failed to resubmit (1)
uhci_hcd 0000:00:1d.3: release dev 2 ep81-INT, period 1, phase 0, 23
us
btusb_bulk_complete: hci0 urb f3b57680 failed to resubmit (1)
btusb_bulk_complete: hci0 urb f3b57718 failed to resubmit (1)
usb 5-1: usb suspend
usb 5-1: usb auto-resume
uhci_hcd 0000:00:1d.3: port 1 portsc 0095,01
usb 5-1: finish resume
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23
us
hub 5-0:1.0: port 1 nyet suspended
hub 5-0:1.0: suspend error -16
pm_op(): usb_dev_suspend+0x0/0x10 returns -16
PM: Device usb5 failed to suspend: error -16
PM: Some devices failed to suspend
thinkpad_acpi: ACPI backlight control delay disabled
usb 5-2: usb resume
uhci_hcd 0000:00:1d.3: port 2 portsc 00a5,01
usb 5-2: finish resume
usb usb4: usb resume
usb usb4: wakeup_rh

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
