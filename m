Return-Path: <linux-kernel-owner+w=401wt.eu-S932261AbZE0OtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932261AbZE0OtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 10:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932080AbZE0Osv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 10:48:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39795 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069AbZE0Osv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 10:48:51 -0400
Message-ID: <4A1D52B7.50701@ti.com>
Date: Wed, 27 May 2009 09:48:23 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 0/2] Dynamic Tick: Enabling longer sleep times on 32-bit machines
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series ensures that the wrapping of the clocksource will not 
be missed if the kernel sleeps for longer periods and allows 32-bit 
machines to sleep for longer than 2.15 seconds.

Jon Hunter (2):
   Dynamic Tick: Prevent clocksource wrapping during idle
   Dynamic Tick: Allow 32-bit machines to sleep for more than 2.15
     seconds

  include/linux/clockchips.h |    6 ++--
  include/linux/time.h       |    1 +
  kernel/hrtimer.c           |    2 +-
  kernel/time/clockevents.c  |   10 ++++----
  kernel/time/tick-oneshot.c |    2 +-
  kernel/time/tick-sched.c   |   36 +++++++++++++++++++++++----------
  kernel/time/timekeeping.c  |   47 
++++++++++++++++++++++++++++++++++++++++++++
  kernel/time/timer_list.c   |    4 +-
  8 files changed, 85 insertions(+), 23 deletions(-)
