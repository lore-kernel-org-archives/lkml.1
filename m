Return-Path: <linux-kernel-owner+w=401wt.eu-S935063AbXLNAH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935063AbXLNAH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934809AbXLNAHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:07:19 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:36858 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934974AbXLNAHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:07:16 -0500
Date: Thu, 13 Dec 2007 19:06:35 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Remy Bohmer <linux@bohmer.net>
cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: 2.6.23.9-rt13
In-Reply-To: <3efb10970712130243t2172907cm31c5d3af29383c8b@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0712131903020.13748@gandalf.stny.rr.com>
References: <1197524036.15001.15.camel@localhost.localdomain>
 <3efb10970712130243t2172907cm31c5d3af29383c8b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Remy,

This would have been better to send this as two separate
patches. They are two different issues.

On Thu, 13 Dec 2007, Remy Bohmer wrote:
> If I compile -rt13 I get some compile warnings on ARM (AT91):
> 1) This one did not exist in rt1:
> In file included from kernel/sched.c:911:
> kernel/sched_rt.c: In function 'dec_rt_tasks':
> kernel/sched_rt.c:88: warning: unused variable 'highest_prio'

This is from Gregory Haskins' patch. He forgot to compile check for
warnings on UP again ;-)

> 2)  This one is there already for a much longer time:
> CC      kernel/rcupreempt.o
> kernel/rcupreempt.c:1001: warning: 'per_cpu__rcu_dyntick_snapshot'
> defined but not used

This was a merge conflict being solved incorrectly.

>
> Both warnings are fixed by the attached patch, but warning 2 needs some review.
> This var is defined twice in this file, 1 in the NO_HZ ifdef, and 1
> which seems to be not used.

Yeah, I'll look into it since I wrote that usage ;-)

Greg,

Can you merge the first part into your patch and resend it to me.

I'll look at the second one.

Thanks,

-- Steve
