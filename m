Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbYEHKaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbYEHKaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 06:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759373AbYEHKaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 06:30:05 -0400
Received: from www.tglx.de ([62.245.132.106]:41814 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759337AbYEHKaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 06:30:03 -0400
Date: Thu, 8 May 2008 12:29:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Knoblauch <spamtrap@knobisoft.de>
cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org,
       hmh@hmh.eng.br
Subject: Re: 2.6.25.2 - Jiffies/Time jumping back and forth (Regereesion from
 2.6.24)
In-Reply-To: <530038.77501.qm@web32608.mail.mud.yahoo.com>
Message-ID: <alpine.LFD.1.10.0805081227250.3318@apollo.tec.linutronix.de>
References: <530038.77501.qm@web32608.mail.mud.yahoo.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Martin Knoblauch wrote:
> > no this looks different. As soon as the timesource is detected, I see non-zero 
> > timestamps
> > in dmesg, but they look smaller and jump in both directions. And I have never 
> > seen this before
> > 2.6.25.
> > 
> > It actually might be a good idea to get the dmesg output from 2.6.24.
> > 
> > Cheers
> > Martin
> 
>  interesting - maybe related to clocksources. The HPET seems to be detected later in 2.6.25:
> 
> 2.6.24:
> 
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> -->[    0.000000] hpet clockevent registered
> -->[    0.000000] TSC calibrated against HPET
 
> 2.6.25.2:
> 
> [    0.000000] Initializing CPU#0
> [    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
> -->[    0.000000] TSC calibrated against PM_TIMER
 
That's odd indeed. Is HPET not registered at all in 2.6.25 or does it just happen late ?

please provide the output of:
/sys/devices/system/clocksource/clocksource0/available_clocksource
/sys/devices/system/clocksource/clocksource0/current_clocksource

Thanks,
	tglx
