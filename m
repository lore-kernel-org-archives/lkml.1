Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZEBJzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZEBJzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZEBJy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:54:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:46277 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995AbZEBJyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:54:55 -0400
Date: Sat, 2 May 2009 09:54:29 GMT
From: tip-bot for Magnus Damm <magnus.damm@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       damm@igel.co.jp, tglx@linutronix.de, magnus.damm@gmail.com
In-Reply-To: <20090501055247.8286.64067.sendpatchset@rx1.opensource.se>
References: <20090501055247.8286.64067.sendpatchset@rx1.opensource.se>
Subject: [tip:timers/clockevents] clockevent: export register_device and delta2ns
Message-ID: <tip-c81fc2c331b8514ad112054cd2d87e6ec132286b@git.kernel.org>
Git-Commit-ID: c81fc2c331b8514ad112054cd2d87e6ec132286b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 02 May 2009 09:54:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c81fc2c331b8514ad112054cd2d87e6ec132286b
Gitweb:     http://git.kernel.org/tip/c81fc2c331b8514ad112054cd2d87e6ec132286b
Author:     Magnus Damm <magnus.damm@gmail.com>
AuthorDate: Fri, 1 May 2009 14:52:47 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 2 May 2009 11:51:07 +0200

clockevent: export register_device and delta2ns

Export the following symbols using EXPORT_SYMBOL_GPL:
 - clockevent_delta2ns
 - clockevents_register_device

This allows us to build SuperH clockevent and clocksource
drivers as modules, see drivers/clocksource/sh_*.c

[ Impact: allow modular build of clockevent drivers ]

Signed-off-by: Magnus Damm <damm@igel.co.jp>
LKML-Reference: <20090501055247.8286.64067.sendpatchset@rx1.opensource.se>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>


---
 kernel/time/clockevents.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
index d13be21..3948fa6 100644
--- a/kernel/time/clockevents.c
+++ b/kernel/time/clockevents.c
@@ -54,6 +54,7 @@ unsigned long clockevent_delta2ns(unsigned long latch,
 
 	return (unsigned long) clc;
 }
+EXPORT_SYMBOL_GPL(clockevent_delta2ns);
 
 /**
  * clockevents_set_mode - set the operating mode of a clock event device
@@ -187,6 +188,7 @@ void clockevents_register_device(struct clock_event_device *dev)
 
 	spin_unlock(&clockevents_lock);
 }
+EXPORT_SYMBOL_GPL(clockevents_register_device);
 
 /*
  * Noop handler when we shut down an event device
