Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZEFCBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZEFCBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757170AbZEFCAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:00:25 -0400
Received: from mail.windriver.com ([147.11.1.11]:50552 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864AbZEFCAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:00:21 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] usb_debug driver improvements
Date: Tue,  5 May 2009 21:00:00 -0500
Message-Id: <1241575205-12199-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
X-OriginalArrivalTime: 06 May 2009 02:00:00.0378 (UTC) FILETIME=[5D0C7DA0:01C9CDEE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After using a USB 2.0 debug device along with the early and standard
usb_debug driver, I came up with some patches to help improve the
functionality of using it with the linux kernel.

The last patch in this series is not meant for upstream merging, it is
marked experimental along with questions.  The first 4 patches in the
series are a request for review, comments and future merge
consideration.

The idea behind this patch series is to allow the USB 2.0 debug device
to operate as both an early printk device and a system console with
the full capability for sysrq.

After resolving the issue with the last patch in the series work can
progress against adding a debugger interface via this connection as
well.

Thanks,
Jason.


The short log and git info is below, which is against the 2.6.30 development tree.

The following changes since commit a425a638c858fd10370b573bde81df3ba500e271:
are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_gregkh

Jason Wessel (5):
      usb_debug: implement multi urb write
      usb_debug,usb_generic_serial: implement sysrq and serial break
      usb,early_printk: insert cr prior to nl as needed
      usb,early_printk: unregister early usb before rest_init()
      usb_debug: EXPERIMENTAL - poll hcd device to force writes

 arch/x86/kernel/early_printk.c |   44 +++++++-
 drivers/usb/core/hcd.c         |    1 +
 drivers/usb/serial/Kconfig     |    7 ++
 drivers/usb/serial/generic.c   |   26 +++--
 drivers/usb/serial/usb_debug.c |  230 ++++++++++++++++++++++++++++++++++++++++
 include/linux/usb/serial.h     |   34 ++++++-
 6 files changed, 323 insertions(+), 19 deletions(-)
