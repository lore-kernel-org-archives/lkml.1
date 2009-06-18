Return-Path: <linux-kernel-owner+w=401wt.eu-S1757613AbZFRCU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613AbZFRCU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 22:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbZFRCUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 22:20:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:55090 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358AbZFRCUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 22:20:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: greg@kroah.com, alan@lxorguk.ukuu.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] usb console regression fixes - 2.6.31
Date: Wed, 17 Jun 2009 21:20:06 -0500
Message-Id: <1245291609-14871-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
X-OriginalArrivalTime: 18 Jun 2009 02:20:14.0484 (UTC) FILETIME=[50799D40:01C9EFBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is aimed to fix the performance and crash regression
with usb console devices.

The first patch in the series fixes the usb console reference counting
which led to a oops during boot.  The test case for this was to use
the FTDI usb serial device with the kernel boot argument
"console=ttyUSB0" and also using the device as an interactive terminal.

The second and third patch optimize the performance of the hot path
for usb serial input processing.

If Alan ack's or signs off on the patches, I'll issue a pull request
to Linus, or we can go another round of revision/review if needed.

Thanks,
Jason.

The short log and git info is below, which is against the 2.6.31
development tree.

The following changes since commit 3fe0344faf7fdcb158bd5c1a9aec960a8d70c8e8:
  Linus Torvalds (1):
        Merge branch 'kmemleak' of git://linux-arm.org/linux-2.6

are available in the git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

Jason Wessel (3):
      usb,console: Fix regression in usb console on kernel boot
      usb-serial: regression fix to move sysrq from hot path
      usb-serial: optimize sysrq function calls

 drivers/usb/serial/console.c    |   13 ++++++-----
 drivers/usb/serial/generic.c    |   41 +++++++++++---------------------------
 drivers/usb/serial/usb-serial.c |    3 +-
 include/linux/usb/serial.h      |   32 ++++++++++++++++++++++++++---
 4 files changed, 49 insertions(+), 40 deletions(-)
