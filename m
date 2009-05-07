Return-Path: <linux-kernel-owner+w=401wt.eu-S1762666AbZEGOAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762666AbZEGOAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:00:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762039AbZEGN4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 09:56:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59746 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762032AbZEGN4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 09:56:39 -0400
Date: Thu, 7 May 2009 09:56:39 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Tim Bird <tim.bird@am.sony.com>, Ryan Mallon <ryan@bluewatersys.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       linux kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: How to use a different sched_clock() for ftrace on omap?
In-Reply-To: <20090507085116.GC19133@elte.hu>
Message-ID: <alpine.DEB.2.00.0905070953170.32734@gandalf.stny.rr.com>
References: <4A022333.8030200@am.sony.com> <20090507085116.GC19133@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 May 2009, Ingo Molnar wrote:

> 
> * Tim Bird <tim.bird@am.sony.com> wrote:
> 
> > Hi all,
> > 
> > I've worked up a replacement sched_clock for ftrace on my omap 
> > platform. The current sched_clock, based on the 32K timer, has low 
> > resolution and doesn't provide very useful results.
> 
> hm, why dont you replace the real sched_clock() with it? High 
> resolution sched_clock() gives (much!) better scheduling, better 
> fairness, etc.

Probably because it is board specific, that he can not replace it. But I 
think something like Ryan's idea would be good. Instead of aliasing, just 
make another weak symbol.


unsigned long long __attribute__((weak)) board_sched_clock(void)
{
	[ original sched_clock code ]
}

unsigned long long sched_clock(void)
{
	return board_sched_clock();
}



Then Tim could define a "board_sched_clock" that would be used when that 
board is active.

-- Steve

