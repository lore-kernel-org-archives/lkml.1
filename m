Return-Path: <linux-kernel-owner+w=401wt.eu-S1756993AbYGGSVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993AbYGGSVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 14:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbYGGSVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 14:21:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021AbYGGSVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 14:21:07 -0400
Message-Id: <20080707181649.942597764@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 07 Jul 2008 14:16:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] sched_clock updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Working with ftrace on linux-tip, I found a few problems with the sched_clock
code that is suppose to help an unstable TSC keep accurate time. The
problem I was seeing was on a box with a stable TSC. The time would
jump around a lot. One would think that code to help unstable TSC keep
time would not be a problem with a stable TSC.

The main change was the patch that handled the dynamic ticks. That was
the culprit of bein off by several jiffies.

With these patches applied, ftrace is quite a bit better with respect to time.
But there is still jumps that happen that do not happen with sched_clock.

I'm suspecting that the problems that still exist have more to do with
time updates or a drift between the TSC and the clock used for GTOD.

Anyway, enjoy,

-- Steve

