Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762Ab0ATMhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762Ab0ATMhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:37:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181Ab0ATMh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:37:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750922Ab0ATMh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:37:28 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Balbir Singh <balbir@in.ibm.com>, linux-kernel@vger.kernel.org,
       Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 0/6 -mm] cpu-timers patches
Date: Wed, 20 Jan 2010 13:34:22 +0100
Message-Id: <1263990868-8119-1-git-send-email-sgruszka@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are patches for cpu-timers I mainly wrote to not call 
thread_group_cputime() in fastpath_timer_check(), which we
discuss in this thread:

http://thread.gmane.org/gmane.linux.kernel/909349/focus=912327
  
On the way I fix some other bugs (SIGEV_NONE timer, old increase value
in timer_settime()) and do other cleanups and optimizations, patch 5
however increase time when sighand->siglock is held. 

Compared with previous send of patches as RFC, I rebased them to -mm
tree, change some changelogs and do some minor code changes.

[PATCH 1/6 -mm] cpu-timers: simplify RLIMIT_CPU handling
[PATCH 2/6 -mm] cpu-timers: cleanup arm_timer()
[PATCH 3/6 -mm] cpu-timers: return correct previous timer reload value
[PATCH 4/6 -mm] cpu-timers: change SIGEV_NONE timer implementation
[PATCH 5/6 -mm] cpu-timers: assure to not iterate over all threads in fastpath_timer_check()
[PATCH 6/6 -mm] cpu-timers: optimize run_posix_cpu_timers()

Cheers
Stanislaw

