Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702Ab0AYIu3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0AYIu3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 03:50:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669Ab0AYIu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 03:50:28 -0500
Received: from www.tglx.de ([62.245.132.106]:60940 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750973Ab0AYIu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 03:50:28 -0500
Date: Mon, 25 Jan 2010 09:46:03 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: d.okias@gmail.com, bugzilla-daemon@bugzilla.kernel.org, x86@kernel.org
Subject: Re: [Bug 15076] System panic under load with
 clockevents_program_event
In-Reply-To: <201001221017.o0MAHQmu015858@demeter.kernel.org>
Message-ID: <alpine.LFD.2.00.1001250831110.2906@localhost.localdomain>
References: <bug-15076-6666@http.bugzilla.kernel.org/> <201001221017.o0MAHQmu015858@demeter.kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switched to email. Please reply to all instead of using the bugzilla
interface.

> --- Comment #4 from okias <d.okias@gmail.com>  2010-01-22 10:17:25 ---
> and it's regression. Now I work on 2.6.32.3 and no problem.

That's a really weird one. The system is 50 min up and running and out
of the blue it crashes in clockevents_program_event(). This function
has been called a couple of thousand times before that point.

The only way to crash there is when *dev is pointing into nirwana. dev
comes from

int tick_program_event(ktime_t expires, int force)
{
        struct clock_event_device *dev = __get_cpu_var(tick_cpu_device).evtdev;

according to the callchain. At this point nothing fiddles with
tick_cpu_device.evtdev, so I suspect some really nasty memory
corruption going on.

okias, can you please disable highmem support and verify whether the
problem persists ?

Thanks,

	tglx
