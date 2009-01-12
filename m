Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbZALJ4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbZALJ4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 04:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbZALJz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 04:55:58 -0500
Received: from rankki.sonarnerd.net ([83.145.240.118]:12332 "EHLO
	mail.sonarnerd.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbZALJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 04:55:57 -0500
Message-ID: <496B13AB.3090407@sonarnerd.net>
Date: Mon, 12 Jan 2009 11:55:55 +0200
From: Jussi Laako <jussi@sonarnerd.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC][PATCH] Multimedia scheduling class
References: <4959198A.3020209@sonarnerd.net> <1230622925.16718.26.camel@twins> <4959DE51.2020605@sonarnerd.net>
In-Reply-To: <4959DE51.2020605@sonarnerd.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jussi Laako wrote:
> Yes, this is for a soft-realtime usage. Some of the tasks are
> CPU-intensive while being realtime'ish, like video codecs and some audio
> processing tasks. These audio processing tasks can have some amount of
> buffering. The idea behind this patch is to make these tasks overlap
> with the normal tasks while giving a slightly more responsive scheduling
> behavior and to favor these multimedia tasks over others.

I've been running a kernel with the scheduler patch on my x86-64 desktop
since Christmas.

Here are some test results... Workload in these tests is mostly starting
a browser and rendering a set of reasonably heavy pages which creates
CPU load spikes. BKL is a bit of a problem too...

I think this is reasonably good result.


Results for the deskop (x86-64), voluntary preempt enabled (as the
proprietary ATI display driver behaves badly with full preempt):

SCHED_OTHER:
maximum latency: 45098.2 µs
average latency: 366.2 µs
missed timer events: 16

SCHED_MM:
maximum latency: 10051.2 µs
average latency: 44.7 µs
missed timer events: 0

SCHED_FIFO:
maximum latency: 720.3 µs
average latency: 23.1 µs
missed timer events: 0


Results for an OMAP3-based platform, preempt enabled:

SCHED_OTHER:
maximum latency: 44.7 ms
average latency: 1.8 ms
missed timer events: 227

SCHED_MM:
maximum latency: 19.2 ms
average latency: 1.1 ms
missed timer events: 23

SCHED_FIFO:
maximum latency: 10.7 ms
average latency: 0.7 ms
missed timer events: 1


Best regards,

	- Jussi Laako
