Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbZKLHp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbZKLHp1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 02:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbZKLHpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 02:45:24 -0500
Received: from smtp.nokia.com ([192.100.122.233]:33726 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZKLHpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 02:45:21 -0500
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Cc: Samu Onkalo <samu.p.onkalo@nokia.com>
Subject: [RFC PATCH 0/1] Driver for ami305 magnetometer
Date: Thu, 12 Nov 2009 09:44:25 +0200
Message-Id: <1258011866-25972-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.5.6.3
X-OriginalArrivalTime: 12 Nov 2009 07:44:30.0522 (UTC) FILETIME=[F7E6A9A0:01CA636B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides driver for two sw compatible 3 axis magnetometer chips
(AMI305 / AK8974). 
Driver provides coordinates as polled input device.
Chip can provide interrupt when the measurement result is ready, but
this feature is not used. Instead, new measurement is started at polling
event frequency. This method allows more flexible measurement interval.
Activity level at kernel side is about the same in both interrupt and polling
based methods. Furhtermore, this eliminate need to use interrupt line at HW
level. 

Chip is powered on when the polled device is opened and powered down when the
device is closed. Axes can be remapped via platform data. 

sysfs interface:
selftest - Perform chip specific selftest as specified by manufacturer
active - returns chip power state: ON or OFF
fuzz - adjust input system "fuzziness" parameter

Patch is applicable to Dmitry Torokhov's input tree - next branch. 
This tree was selected since patch requires a change to polled
input device which is allready in that tree (open / close methods).

Samu Onkalo (1):
  AMI305 magnetometer driver

 drivers/misc/Kconfig       |   11 +
 drivers/misc/Makefile      |    1 +
 drivers/misc/ami305.c      |  644 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/ami305.h |   22 ++
 4 files changed, 678 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/ami305.c
 create mode 100644 include/linux/i2c/ami305.h
