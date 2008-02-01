Return-Path: <linux-kernel-owner+w=401wt.eu-S1761511AbYBABk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761511AbYBABk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 20:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYBABkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 20:40:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56341 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012AbYBABkP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 20:40:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [Regression] 2.6.24-git9: RT sched mishandles artswrapper (bisected)
Date: Fri, 1 Feb 2008 02:37:58 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802010237.59320.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is related to the problem I reported earlier this week:
http://lkml.org/lkml/2008/1/30/554

Apparently artswrapper, run by KDE in openSUSE 10.3 with a real time priority,
is mishandled by the scheduler.  The problem is that after the user logs out,
artswrapper stays in TASK_RUNNING forever and prevents other tasks from being
scheduled on the CPU occupied by it.  In this state it also breaks suspend and
hibernation (it cannot be frozen).

Since the problem is 100% reproducible on my test boxes, I carried out a
bisection which turned out the following commit:

commit 6f505b16425a51270058e4a93441fe64de3dd435
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Jan 25 21:08:30 2008 +0100

    sched: rt group scheduling

I'm now checking if the problem disappears after reverting this patch (along a
couple of dependent ones).

Thanks,
Rafael
