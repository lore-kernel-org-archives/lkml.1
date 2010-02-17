Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755107Ab0BQWhn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 17:37:43 -0500
Received: from [12.234.97.163] ([12.234.97.163]:49164 "EHLO
	archaeopteryx.synaptics.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753302Ab0BQWhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 17:37:42 -0500
From: Christopher Heiny <cheiny@synaptics.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Christopher Heiny <cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>
Subject: [RFC PATCH 0/1] input/touchscreen: Synaptics Touchscreen Driver
Date: Wed, 17 Feb 2010 14:37:36 -0800
Message-Id: <1266446258-16209-1-git-send-email-cheiny@synaptics.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[This is a resend of a patch sent earlier this month - apologies
for the duplication, but I botched some of the addressing in the
previous submission (neglecting to include Dmitry), as well as the
cover note.]

This patch adds an initial driver supporting Synaptics ClearPad
touchscreens that use the RMI4 protocol, as defined here:

http://www.synaptics.com/sites/default/files/511-000136-01_revA.pdf


Differences to the previous RFC PATCH sent include:
    - proper line wrapping (sending with get-sendemail)
    - extensive changes to make checkpatch.pl happy.  Not all errors were
      eliminated, because in a couple of cases we couldn't figure out what the
      problem was.
    - i2c interface updated to reflect recent i2c changes in the kernel.


This version of the driver does not support all features of the RMI4
protocol yet.  We felt it more important to start with a solid
implementation of the basic functionality, and then build on that base
to support additional features (such as gestures, proximity detection,
capacitive buttons, and so on).

Additionally, as this is our team's first venture into the wonderful
world of kernel submissions, we figured it was important to start out
initially with a fairly simple codebase, just in case we're doing
something horribly wrong.


The significant files in this version of the driver are:
      rmi_core.c
          Implements the basic core of the RMI4 protocol
          including self-discovery of RMI4 functions.  This
          also implements RMI4 function 0x01, which provides
          generic device control.
      rmi_function_11.c
          Implements basic RMI4 function 0x11 (2D sensor)
          features, including multitouch up to 10 fingers.
      rmi_app_touchpad.c
          The major driver functions (mod_init, mod_exit,
          and so on).
More detailed descriptions can be found in each file's comments.

We chose to use multiple source files because it makes it easy to add
support for additional RMI4 functions with minimal impact to existing
functions.  Additionally, this supports future changes to the
configuration to allow you to compile in only those RMI4 functions that
you need for your particular device.


There are two existing drivers for similar Synaptics devices in the
current kernel tree (excluding the PS/2 touchpad driver).  These are:

./linux-2.6/drivers/input/mouse/synaptics_i2c.c
      A driver for the Exeda 15mm touchpad, written by Mike Rapoport
      <mike@compulab.co.il> and Igor Grinberg <grinberg@compulab.co.il>

./linux-2.6/drivers/staging/dream/synaptics_i2c_rmi.c
      A driver for the HTC Dream ClearPad, written by Arve Hjønnevåg
      <arve@android.com>

We have not extended these drivers for a couple of reasons.  First, the
two drivers are specific to particular Synaptics products, and it is our
desire to produce a general solution that takes advantage of the 'self
describing' features of products that use the RMI protocol.

Second, and more importantly, is that the existing drivers are written
for an older version of the RMI protocol (aka RMI3) that is being
retired in favor of a more recent and substantially changed version (aka
RMI4).  Most currently shipping Synaptics ClearPads speak the RMI4
protocol, and it will be Synaptics protocol of choice going forward.  In
almost all respects, RMI4 is not backward compatible with RMI3, making
it impractical to support both versions in the same driver.


Comments and other feedback on this driver are welcomed.

Bill Manson
Allie Xiong
Christopher Heiny



---
