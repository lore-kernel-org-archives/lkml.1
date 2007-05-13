Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbXEMRdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbXEMRdP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 13:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXEMRdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 13:33:03 -0400
Received: from www.osadl.org ([213.239.205.134]:33341 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751006AbXEMRdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 13:33:00 -0400
Subject: Re: [patch] make pit clocksource continuous
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <46474975.1080204@aknet.ru>
References: <46464B5C.2080302@aknet.ru>
	 <1179040612.22481.237.camel@localhost.localdomain>
	 <4646D493.9000309@aknet.ru>
	 <1179068094.22481.248.camel@localhost.localdomain>
	 <46474175.7030205@aknet.ru>
	 <1179075026.22481.273.camel@localhost.localdomain>
	 <46474975.1080204@aknet.ru>
Content-Type: text/plain
Date: Sun, 13 May 2007 19:36:12 +0200
Message-Id: <1179077772.22481.279.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-05-13 at 21:23 +0400, Stas Sergeev wrote:
> Hello.
> 
> Thomas Gleixner wrote:
> >> Does this mean that on even an older
> >> boards (without acpi at all) the hrtimers
> >> won't work?
> > Not if PIT is the only clocksource available.
> So you mean it can work without both the
> pm_timer and hpet? Sorry for bothering you
> too much, but I am trying to use the hrtimers
> in my driver module, so I'd like to know all
> the corner-cases.

It does _NOT_ work without pm_timer or hpet for the reasons explained
before. 

When PIT is the only clocksource in the system, i.e. no HPET and no
PM_TIMER is available, then highres and dynticks are disabled.

> How can I test that situation when the hrtimers
> work only with PIT? Apparently disabling the
> pm_timer and hpet in config doesn't help testing
> it at all, since it simply refuses to work then.

It is supposed to refuse to switch to highres / dyntick when you
disabled pm_timer and hpet.

> Should I use hrtimer_get_res() to see if the
> hrtimers are available, or is there any better way?

hrtimer_get_res() works, but I have no idea why you need hrtimers in
your driver at all.

	tglx


