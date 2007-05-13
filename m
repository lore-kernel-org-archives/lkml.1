Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbXEMJBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbXEMJBw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 05:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756441AbXEMJBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 05:01:45 -0400
Received: from mail.aknet.ru ([82.179.72.26]:63926 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbXEMJBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 05:01:44 -0400
Message-ID: <4646D493.9000309@aknet.ru>
Date: Sun, 13 May 2007 13:04:19 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: tglx@linutronix.de
CC: Daniel Walker <dwalker@mvista.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] make pit clocksource continuous
References: <46464B5C.2080302@aknet.ru> <1179040612.22481.237.camel@localhost.localdomain>
In-Reply-To: <1179040612.22481.237.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Thomas Gleixner wrote:
> The PIT can only be used as a clock source, when it is in periodic mode,
> but it is never continuous. If we miss one PIT interrupt the time
> keeping is hosed.
OK, thank you and Daniel for the explanations
about the flag, but now to the problem.
Before hrtimer_switch_to_hres() is called,
the check for timekeeping_is_continuous() is
performed in tick_ckeck_oneshot_change(), and
that check fails (by adding a flag I compel it
to succeed). With that check failing,
hrtimer_switch_to_hres() is never called, and
the hrtimers do not work. That's why I posted
that patch, but what would be the right way
of getting the hrtimers to work?
/proc/timer_list lists only the pit timesource.
If I enable lapic then it is also listed, yet
it doesn't help at all.

