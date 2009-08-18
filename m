Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbZHRRpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbZHRRpe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759423AbZHRRpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:45:33 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39918 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759201AbZHRRpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:45:30 -0400
From: Jon Hunter <jon-hunter@ti.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Jon Hunter <jon-hunter@ti.com>
Subject: [PATCH 0/2] Dynamic Tick: Enabling longer sleep times on 32-bit machines
Date: Tue, 18 Aug 2009 12:45:09 -0500
Message-Id: <1250617512-23567-1-git-send-email-jon-hunter@ti.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Hunter <jon-hunter@ti.com>

This is a resend of the patch series shown here:
http://www.spinics.net/lists/kernel/msg891029.html

This patch series has been rebase on the linux-2.6-tip timers/core branch per
request from Thomas Gleixner.

This patch series ensures that the wrapping of the clocksource will not be
missed if the kernel sleeps for longer periods and allows 32-bit machines to
sleep for longer than 2.15 seconds.

Jon Hunter (2):
  Dynamic Tick: Prevent clocksource wrapping during idle
  Dynamic Tick: Allow 32-bit machines to sleep for more than 2.15
    seconds

 include/linux/clockchips.h  |    6 ++--
 include/linux/clocksource.h |    2 +
 include/linux/time.h        |    1 +
 kernel/hrtimer.c            |    2 +-
 kernel/time/clockevents.c   |   10 ++++----
 kernel/time/clocksource.c   |   47 +++++++++++++++++++++++++++++++++++
 kernel/time/tick-oneshot.c  |    2 +-
 kernel/time/tick-sched.c    |   57 ++++++++++++++++++++++++++++++++----------
 kernel/time/timekeeping.c   |   11 ++++++++
 kernel/time/timer_list.c    |    4 +-
 10 files changed, 116 insertions(+), 26 deletions(-)

