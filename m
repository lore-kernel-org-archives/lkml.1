Return-Path: <linux-kernel-owner+w=401wt.eu-S1768515AbXEMOvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768515AbXEMOvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 10:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbXEMOvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 10:51:45 -0400
Received: from www.osadl.org ([213.239.205.134]:50370 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752490AbXEMOvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 10:51:44 -0400
Subject: Re: [patch] make pit clocksource continuous
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stas Sergeev <stsp@aknet.ru>
Cc: Daniel Walker <dwalker@mvista.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4646D493.9000309@aknet.ru>
References: <46464B5C.2080302@aknet.ru>
	 <1179040612.22481.237.camel@localhost.localdomain>
	 <4646D493.9000309@aknet.ru>
Content-Type: text/plain
Date: Sun, 13 May 2007 16:54:53 +0200
Message-Id: <1179068094.22481.248.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 13:04 +0400, Stas Sergeev wrote:
> Hello.
> 
> Thomas Gleixner wrote:
> > The PIT can only be used as a clock source, when it is in periodic mode,
> > but it is never continuous. If we miss one PIT interrupt the time
> > keeping is hosed.

> OK, thank you and Daniel for the explanations
> about the flag, but now to the problem.
> Before hrtimer_switch_to_hres() is called,
> the check for timekeeping_is_continuous() is
> performed in tick_ckeck_oneshot_change(), and
> that check fails (by adding a flag I compel it
> to succeed).

It succeeds, but it does not work correctly, because your time keeping
is unreliable.

>  With that check failing,
> hrtimer_switch_to_hres() is never called, and
> the hrtimers do not work. That's why I posted
> that patch, but what would be the right way
> of getting the hrtimers to work?
> /proc/timer_list lists only the pit timesource.
> If I enable lapic then it is also listed, yet
> it doesn't help at all.

You need either pm_timer or hpet in order to switch to highres /
dynticks. Are those enabled in the kernel config ?

	tglx



