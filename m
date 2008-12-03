Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbYLCXqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbYLCXqj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 18:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYLCXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 18:46:29 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:47743 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbYLCXq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 18:46:29 -0500
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
Date: Wed, 03 Dec 2008 15:36:29 -0800
In-Reply-To: <alpine.DEB.1.10.0812031551360.29045@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Wed, 3 Dec 2008 15:52:24 -0500 (EST)")
Message-ID: <m1y6yw25mq.fsf@frodo.ebiederm.org>
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

>> >  # echo $$ > /debugfs/tracing/set_ftrace_pid
>> >  # echo function_graph > /debugfs/tracing/current_tracer
>> > 
>> > Will cause only the current task to be traced. Note, the trace flags are
>> > also inherited by child processes, so the children of the shell
>> > will also be traced.
>> 
>> Where did we end up on the pids-arent-unique issue?  Gave up?
>
> Nah, patch 2 opens the door for a solution. I'm just pawning the work off 
> to the container folks ;-)

The way patch 2 uses pids is just stupid.  It has nothing to do with
pids aren't unique.  You do a full walk of the process list instead
of using the hash table.

It makes me think that task->pid really should go away because with it
there people don't bother to look and see how things normally work.

Eric
