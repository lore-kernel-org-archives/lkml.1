Return-Path: <linux-kernel-owner+w=401wt.eu-S1753106AbYLEHqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106AbYLEHqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 02:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750805AbYLEHqc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 02:46:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:44061 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYLEHqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 02:46:31 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
References: <20081204052638.425740534@goodmis.org>
	<20081204052735.362609481@goodmis.org>
	<20081204001803.598063f5.akpm@linux-foundation.org>
	<20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com>
	<m11vwnu10b.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com>
	<m1vdtzr4zn.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812041653270.32726@gandalf.stny.rr.com>
Date: Thu, 04 Dec 2008 23:43:52 -0800
In-Reply-To: <alpine.DEB.1.10.0812041653270.32726@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 4 Dec 2008 16:56:28 -0500 (EST)")
Message-ID: <m1r64nqd6v.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Steven Rostedt <rostedt@goodmis.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> On Thu, 4 Dec 2008, Eric W. Biederman wrote:
>> 
>> Right.  I simply meant most of the
>> if (likely(p->pid)) conditional except for the counts is pretty much a don't
>> care.  Keeping the idle tasks off of the process list and out of the counts
>> is useful.
>> 
>> For this particular case what problem did you see with calling attach_pid
>> with PIDTYPE_PID on init_struct_pid?
>
> On boot up, the CPU 0 idle task is attached to init_struct_pid, and not 
> the others. If you do a "attach_pid" on the next idle task that is created, 
> it will become the attched process, bumping off CPU 0's idle task from the 
> init_struct_pid.

It should form a linked list.  For other pid types we don't have a problem.

> When doing the code you suggested, I end up with only marking the last 
> idle task to be created.

Odd. It is all a linked list through the task structures.
I'm guessing the initialization isn't quite right.

Weird.  

Eric






