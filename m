Return-Path: <linux-kernel-owner+w=401wt.eu-S966347AbXDGVbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966347AbXDGVbz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 17:31:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966350AbXDGVbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 17:31:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:20285 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966347AbXDGVbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 17:31:55 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: Daniel Walker <dwalker@mvista.com>
To: tglx@linutronix.de
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, mingo@elte.hu
In-Reply-To: <1175979019.28263.523.camel@localhost.localdomain>
References: <20070405210316.785839431@mvista.com>
	 <20070407031922.ee49478f.akpm@linux-foundation.org>
	 <1175967839.15973.156.camel@imap.mvista.com>
	 <1175979019.28263.523.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 14:30:31 -0700
Message-Id: <1175981431.15973.158.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 22:50 +0200, Thomas Gleixner wrote:
> On Sat, 2007-04-07 at 10:43 -0700, Daniel Walker wrote:
> > Looks like this path ,
> > 
> > arch/i386/kernel/tsc.c: time_cpufreq_notifier(); <-- takes xtime_lock
> > 			 mark_tsc_unstable();
> >             		  clocksource_change_rating(&clocksource_tsc, 0);
> > 			   timekeeping_change_clocksource(); <-- takes xtime_lock
> > 
> > 
> > I'm not sure why the time_cpufreq_notifier is taking the xtime_lock tho .
> 
> Simply because it fiddles with variables which are relevant for
> timekeeping.

loops_per_jiffy perhaps?



