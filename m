Return-Path: <linux-kernel-owner+w=401wt.eu-S965423AbXBFUTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965423AbXBFUTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965396AbXBFUTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:19:55 -0500
Received: from www.osadl.org ([213.239.205.134]:37808 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965423AbXBFUTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:19:54 -0500
Subject: Re: 2.6.20-rc6-mm3
From: Thomas Gleixner <tglx@linutronix.de>
To: dwalker@mvista.com
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, mingo@elte.hu
In-Reply-To: <1170791739.3455.3.camel@dwalker1>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	 <1170777802.9781.353.camel@imap.mvista.com> <1170786992.3785.0.camel@chaos>
	 <1170787543.9781.362.camel@imap.mvista.com> <1170788870.3785.9.camel@chaos>
	 <1170791739.3455.3.camel@dwalker1>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 21:20:06 +0100
Message-Id: <1170793206.3785.16.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-06 at 11:55 -0800, Daniel Walker wrote:
> > What kind of artificial problem are you creating here ?
>
> I'm not trying to create anything .. However, as I said before
> the /proc/interrupts "timer" entry doesn't work the same as it has in
> other kernels.

Yes, it is different. Why are you insisting, that something is a problem
just because it is different ?

> If you think that isn't a problem then explain why ..

Simply because it works and it does not make any sense to have a per cpu
timer (lapic) and the PIT firing at the same periodic interval. PIT does
nothing else than jiffies64++. The clockevents code just optimizes that
away and lets one cpu do the jiffies64++ in its periodic per cpu
interrupt.

So where is the problem ?

> > > We could just remove the timer entry .
> > 
> > No we can't. The timer interrupt is setup and it does not go away, as we
> > keep the PIT as a backup for the broken lapics.
> 
> Ok, how about adding the interrupts to the list which are driving the
> timer ?

Uurg. /proc/interrupts has nothing to do with timers. It's interrupts
statistics. See LOC entry for the lapic ones.

	tglx


