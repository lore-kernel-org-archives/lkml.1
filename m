Return-Path: <linux-kernel-owner+w=401wt.eu-S1753838AbYJ3CSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbYJ3CSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYJ3CSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:18:14 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54110 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751773AbYJ3CSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:18:13 -0400
To: linux-kernel@vger.kernel.org
Subject: [REGRESSION 2.6.28-rc2-git3] lots of extra timer interrupts costing 2W
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1KvN6w-0002QE-E3@closure.thunk.org>
Date: Wed, 29 Oct 2008 22:18:10 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've noticed that sometime between 2.6.27-git7 and 2.6.28-rc2-git3,
powertop is reporting a huge number of excess timer interrupts on my
x61s laptop:

Wakeups-from-idle per second : 617.8    interval: 3.1s
no ACPI power usage estimate available

Top causes for wakeups:
  71.3% (543.7)       <interrupt> : extra timer interrupt 
  13.5% (103.0)     <kernel core> : hrtimer_start_expires (tick_sched_timer) 
   7.2% ( 55.0)      <kernel IPI> : Rescheduling interrupts 
   1.7% ( 13.0)    gnome-terminal : hrtimer_start_expires (hrtimer_wakeup) 
   1.4% ( 10.3)       <interrupt> : PS/2 keyboard/mouse/touchpad 
   1.1% (  8.3)       <interrupt> : ahci
   0.4% (  3.3)   multiload-apple : hrtimer_start_expires (hrtimer_wakeup)
   0.3% (  2.7)              Xorg : hrtimer_start (it_real_fn)


This is costing me an extra 2 Watts or so.   Does this ring a bell with
anyone, before I start trying to bisect this problem?

						- Ted
