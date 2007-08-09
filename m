Return-Path: <linux-kernel-owner+w=401wt.eu-S937738AbXHIRR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937738AbXHIRR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 13:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765745AbXHIRRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 13:17:48 -0400
Received: from xmrt0101.northgrum.com ([208.20.220.55]:3522 "EHLO
	xmrt0101.northgrum.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765534AbXHIRRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 13:17:47 -0400
Subject: Re: [PATCH] at91 pm: Compilation fix for at91sam926x
From: Andy Herzig <andrew.herzig@ngc.com>
To: Marc Pignat <marc.pignat@hevs.ch>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       =?ISO-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>,
       andrew@sanpeople.com, trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200708091801.20077.marc.pignat@hevs.ch>
References: <1186661447.6370.19.camel@leoh9-18574.nges.northgrum.com>
	 <200708091653.35226.hjk@linutronix.de>
	 <200708091801.20077.marc.pignat@hevs.ch>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 09 Aug 2007 13:17:53 -0400
Message-Id: <1186679874.17413.12.camel@leoh9-18574.nges.northgrum.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7) 
X-OriginalArrivalTime: 09 Aug 2007 17:17:43.0767 (UTC) FILETIME=[32A9DE70:01C7DAA9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 18:01 +0200, Marc Pignat wrote:

> > > +#if defined(CONFIG_ARCH_AT91RM9200)
> > >                         at91_sys_write(AT91_SDRAMC_SRR, 1);     /*
> > > self-refresh mode */
> Why don't use:
> if (cpu_is_at91rm9200())
> 	at91_sys_write(AT91_SDRAMC_SRR, 1);
> 
No reason. That looks good to me.

> > >  #ifdef CONFIG_PM
> > > +extern int at91_suspend_entering_slow_clock(void);
> Why do you define 3 times this function?
> Can't you place it in a .h?
I considered a .h, but I didn't see one that all drivers included. I
declare it in the 3 separate driver .c files that I saw needed it. There
is no pm.h and I didn't see the point in creating one just for that.
That of course will work if everyone likes that better. In either case,
you still have to add something to all three files.

-Andy H.
