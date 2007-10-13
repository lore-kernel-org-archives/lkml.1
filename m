Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbXJMHTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbXJMHTS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 03:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbXJMHTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 03:19:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:60760 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753586AbXJMHTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 03:19:02 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9Ykw+k8O9VoAV52MCzpiO//bhelRzLkFxsP8PZz
	s4bVkCgHqn5bzC
Subject: Re: [PATCH] sched: high-res preemption tick
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1192222309.5897.3.camel@lappy>
References: <1192222309.5897.3.camel@lappy>
Content-Type: text/plain
Date: Sat, 13 Oct 2007 09:18:58 +0200
Message-Id: <1192259938.7369.4.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-12 at 22:51 +0200, Peter Zijlstra wrote:
> Subject: sched: high-res preemption tick
> 
> Use HR-timers (when available) to deliver an accurate preemption tick.

This patch further reduced iperf context switching, and boosted
throughput.

iperf -c localhost -P 10 -t 300

Previously reported numbers

2.6.23-smp
[SUM]  0.0-300.0 sec    153 GBytes  4.39 Gbits/sec
[SUM]  0.0-300.1 sec    148 GBytes  4.23 Gbits/sec
[SUM]  0.0-300.0 sec    152 GBytes  4.36 Gbits/sec

2.6.23-smp-d (sched-devel)
[SUM]  0.0-300.0 sec    173 GBytes  4.96 Gbits/sec
[SUM]  0.0-300.1 sec    173 GBytes  4.96 Gbits/sec
[SUM]  0.0-300.0 sec    172 GBytes  4.93 Gbits/sec

Numbers from fresh pull today

2.6.23-smp-d-hrt
(re-enable PREEMPT_RESTRICT)
[SUM]  0.0-300.1 sec    181 GBytes  5.19 Gbits/sec
[SUM]  0.0-300.0 sec    182 GBytes  5.22 Gbits/sec
[SUM]  0.0-300.1 sec    182 GBytes  5.22 Gbits/sec

2.6.23-smp-d
[SUM]  0.0-300.1 sec    174 GBytes  4.97 Gbits/sec
[SUM]  0.0-300.1 sec    173 GBytes  4.95 Gbits/sec
[SUM]  0.0-300.1 sec    173 GBytes  4.96 Gbits/sec


