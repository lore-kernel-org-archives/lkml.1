Return-Path: <linux-kernel-owner+w=401wt.eu-S932809AbZIQDIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932809AbZIQDIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 23:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758210AbZIQDIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 23:08:18 -0400
Received: from mail.windriver.com ([147.11.1.11]:54805 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241AbZIQDIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 23:08:17 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: gregkh@suse.de
Cc: linux-usb@vger.kernel.org, stern@rowland.harvard.edu,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] usb console: 2.6.32 regression fixes
Date: Wed, 16 Sep 2009 22:08:04 -0500
Message-Id: <1253156887-31597-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 17 Sep 2009 03:08:14.0401 (UTC) FILETIME=[18A15310:01CA3744]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are 3 regressions in the 2.6.32 development stream for the usb
serial console.

1) A hang in the usb serial core due to a unfreed mutex

2) Crash in the usb serial core if you use a serial console
   because there is a double open of the low level device

3) It is not possible to pass the console baud rate on to
   the first tty open for any usb serial driver other
   than the pl2303 (which has device specific baud
   management).

The first open of the usb serial HW has the termios initialized to
9600 baud, and this will override what ever was setup via the original
console initialization.  The solution is to save the console baud rate
and re-use it later on the first open.

This patch series only applies to the end of the Greg KH usb tree.  It
was tested with a pl2303, mct_u232 and ftdi_sio usb serial devices.

Jason.

Jason Wessel (3):
      usb console: fix mutex lock regression
      usb console,usb-serial: fix regression use of serial->console
      usb console,usb-serial: pass initial console baud on to first tty open

 drivers/usb/serial/console.c    |    2 ++
 drivers/usb/serial/usb-serial.c |   32 +++++++++++++++++---------------
 include/linux/usb/serial.h      |    1 +
 3 files changed, 20 insertions(+), 15 deletions(-)
