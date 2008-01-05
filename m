Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYAEDZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYAEDZb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 22:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYAEDZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 22:25:22 -0500
Received: from ishtar.tlinx.org ([64.81.245.74]:55170 "EHLO ishtar.tlinx.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752558AbYAEDZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 22:25:22 -0500
Message-ID: <477EF8A4.7010507@tlinx.org>
Date: Fri, 04 Jan 2008 19:25:24 -0800
From: Linda Walsh <lkml@tlinx.org>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: general config preemption Q: preempt-model and Big-Lock Preemption
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A question that comes to mind every time I go through the settings
for "Preemption Model" and "Preempt The Big Kernel Lock".

Do each of the combinations "make sense", or are some "no-ops"?
For model, we have 1) no forced (server), 2) Voluntary (Desktop)
3) preemptible (low-latency Desktop), and for Big Lock Preemption (BLP),
we have "yes" or "no".

Questions:

1) What is the difference between "no forced" and "voluntary"?  Doesn't
  voluntary normally mean "not forced"?

2) If a process is not preemptible, then it seems this would be "doubly
  so" in the kernel when the big-lock is held.  So does the big-lock
  preemption question have any effect (when preempt-model="no forced").

3) If a process is "fully preemptible" but "BLP=false", is that
  much different than "voluntary preemption" & BLP=false?  I.e. --
  should 'preemptible kernel' also imply "BLP=true"...i.e.

_Should_ (would?) the following change be "somewhat" identical to
current config options:

  O1) "Preempt Model"="no-forced preemption" (would set
  preempt-big-kern-lock to FALSE and doesn't display that question).

  O2) "Voluntary Preemption" (presuming there are voluntary preemption
  points in the kernel in places where the big-K-lock is held), then
  configuration would still ask whether to  "Preempt The Big Kernel Lock".

  O3) "Preemptible model"="allow-kernel-preemption" (would set
  preempt-big-kern-lock to TRUE and doesn't display that question).


