Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569AbYLDVqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbYLDVqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:46:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755557AbYLDVqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:46:25 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60642 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbYLDVqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:46:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.362609481@goodmis.org>
	<20081204001803.598063f5.akpm@linux-foundation.org>
	<20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com>
	<m11vwnu10b.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com>
Date: Thu, 04 Dec 2008 13:43:24 -0800
In-Reply-To: <alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 4 Dec 2008 15:57:48 -0500 (EST)")
Message-ID: <m1vdtzr4zn.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: No (on mx04.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Thu, 4 Dec 2008, Eric W. Biederman wrote:
>> >> >
>> >> >> > +static struct pid * const ftrace_swapper_pid = (struct pid *)1;
>> >> >> 
>> >> >> eh?
>> >> >
>> >> > all side-effects of getting rid of the integer based PID namespace and 
>> >> > replacing them with struct pid pointers.
>> >> 
>> >> Thanks for asking Andrew it looks like an unnecessary side effect.
>> >
>> > Well, it was necessary without hacking fork.c ;-)
>> 
>> The (struct pid *)1 has always been unnecessary.
>
> Well, I could set it to the &init_struct_pid as you said, but it will not 
> change any of the code below it. So it does not matter what 
> ftrace_swapper_pid is set to, as long as it is not set to something that 
> can be a legitimate pid struct for something not the swapper task.
>
> It will only matter when we fix the fork code.

Well that and if someone dereferences.  

>> As for fork.  It would be nice to remove most of the special cases
>> for the idle thread.  At least the counts are significant.  The rest
>> is pretty much a don't care at this point.
>
> Well, the swapper task should still have a pid of zero. That is probably 
> important.

Right.  I simply meant most of the
if (likely(p->pid)) conditional except for the counts is pretty much a don't
care.  Keeping the idle tasks off of the process list and out of the counts
is useful.

For this particular case what problem did you see with calling attach_pid
with PIDTYPE_PID on init_struct_pid?

Eric

