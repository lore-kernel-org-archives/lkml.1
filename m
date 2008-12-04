Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYLDE0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYLDE0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 23:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYLDE03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 23:26:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:53226 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbYLDE03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 23:26:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, fweisbec@gmail.com, peterz@infradead.org,
       arjan@infradead.org, dave@linux.vnet.ibm.com, containers@lists.osdl.org,
       sukadev@linux.vnet.ibm.com, serue@us.ibm.com, srostedt@redhat.com
Subject: Re: [PATCH 3/3] ftrace: trace single pid for function graph tracer
References: <20081203203656.776893226@goodmis.org>
	<20081203203829.362295724@goodmis.org>
	<20081203124915.2eb9e7cd.akpm@linux-foundation.org>
	<alpine.DEB.1.10.0812031551360.29045@gandalf.stny.rr.com>
	<m1y6yw25mq.fsf@frodo.ebiederm.org>
	<alpine.DEB.1.10.0812032125340.28153@gandalf.stny.rr.com>
Date: Wed, 03 Dec 2008 20:22:28 -0800
In-Reply-To: <alpine.DEB.1.10.0812032125340.28153@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Wed, 3 Dec 2008 21:29:10 -0500 (EST)")
Message-ID: <m1hc5kvabf.fsf@frodo.ebiederm.org>
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

> On Wed, 3 Dec 2008, Eric W. Biederman wrote:
>
>> Steven Rostedt <rostedt@goodmis.org> writes:
>> 
>> The way patch 2 uses pids is just stupid.  It has nothing to do with
>> pids aren't unique.  You do a full walk of the process list instead
>> of using the hash table.
>
> The way patch 2 uses the pids is stupid, it was just the easiest way to 
> implement it correctly ;-)  I work with, do it stupid but correct first, 
> then optimize.

Which is a reasonable and very unix approach.  As long as I don't need to
do more than advise about what to do.

>> It makes me think that task->pid really should go away because with it
>> there people don't bother to look and see how things normally work.
>
> This is far from a fast path, and I can easily fix it. The hard work was 
> the rest of the patch not this part. I even did it stupid knowing that I 
> would be rewriting it to handle namespaces. I stated that this needed to 
> be fixed in the patch itself.
>
> One thing I never got an answer for, using the namespace pid path, can I 
> still select the idle task to trace, i.e. pid == 0.

Sorry I didn't see this question.  As I recall we have a special pid that
is not hashed that is used by the idle task.  

So it should be possible but it would need to be a special case.  Although
please note we have one idle task per cpu.

Is the idle task doing anything interesting enough to warrant tracing?
We don't report the idle tasks in proc or in any of our other user space
interfaces.

Eric
