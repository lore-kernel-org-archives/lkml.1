Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbZG1AAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbZG1AAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 20:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZG1AAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 20:00:32 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36348 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZG1AAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 20:00:31 -0400
From: Jon Hunter <jon-hunter@ti.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Jon Hunter <jon-hunter@ti.com>
Subject: [PATCH 0/2] Dynamic Tick: Enabling longer sleep times on 32-bit
Date: Mon, 27 Jul 2009 19:00:14 -0500
Message-Id: <1248739216-23761-1-git-send-email-jon-hunter@ti.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Hunter <jon-hunter@ti.com>

This is a resend of the patch series shown here:
http://www.spinics.net/lists/kernel/msg891029.html

This patch series has been updated based on the feedback received and
rebased against the current kernel.

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

