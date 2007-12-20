Return-Path: <linux-kernel-owner+w=401wt.eu-S938011AbXLTPt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938011AbXLTPt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 10:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966082AbXLTPjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 10:39:41 -0500
Received: from ns1.suse.de ([195.135.220.2]:53762 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966067AbXLTPjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 10:39:36 -0500
Message-Id: <20071220153935.069780745@stravinsky.suse.de>
User-Agent: quilt/0.46_cvs20071105-2.3
Date: Thu, 20 Dec 2007 16:39:35 +0100
From: Bernhard Walle <bwalle@suse.de>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, clemens@ladisch.de
Subject: [patch 0/3] Implement CONFIG_HPET_EMULATE_RTC for RTC_DRV_CMOS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new rtc-cmos driver misses HPET support. If the hardware has HPET enabled,
then interrupts don't work for the rtc-cmos driver which results in RTC_AIE*,
RTC_PIE* and RTC_ALM being unusable. This affects hwclock from util-linux-ng
at least on i386 since that uses RTC_PIE_ON. (For x86-64, a polling method is
used for unknown reasons.)

This patch series now

  1. export the functions from arch/x86/kernel/hpet.c that the old char/rtc
     driver uses to work around that problem,

  2. makes it possible to compile the old rtc driver as module, while still
     having CONFIG_HPET_EMULATE_RTC enabled and

  3. makes use of the exported functions in (1) in the new rtc-cmos driver.

The design is not changed. Please review and give me feedback!

This patch series is against 2.6.24-rc5-mm1. It passes the test in
Documentation/rtc.txt after http://lkml.org/lkml/2007/12/20/249 is applied.


Signed-off-by: Bernhard Walle <bwalle@suse.de>

