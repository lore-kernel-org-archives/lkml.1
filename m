Return-Path: <linux-kernel-owner+w=401wt.eu-S1758706AbYLDV4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758706AbYLDV4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 16:56:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756433AbYLDV4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 16:56:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35549 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbYLDV4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 16:56:30 -0500
Date: Thu, 4 Dec 2008 16:56:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, containers@lists.osdl.org,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 3/3] ftrace: add ability to only trace swapper tasks
In-Reply-To: <m1vdtzr4zn.fsf@frodo.ebiederm.org>
Message-ID: <alpine.DEB.1.10.0812041653270.32726@gandalf.stny.rr.com>
References: <20081204052638.425740534@goodmis.org> <20081204052735.362609481@goodmis.org> <20081204001803.598063f5.akpm@linux-foundation.org> <20081204091023.GJ32594@elte.hu> <m1vdu0t7tz.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812040946060.5240@gandalf.stny.rr.com>
 <m11vwnu10b.fsf@frodo.ebiederm.org> <alpine.DEB.1.10.0812041551590.32726@gandalf.stny.rr.com> <m1vdtzr4zn.fsf@frodo.ebiederm.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 4 Dec 2008, Eric W. Biederman wrote:
> 
> Right.  I simply meant most of the
> if (likely(p->pid)) conditional except for the counts is pretty much a don't
> care.  Keeping the idle tasks off of the process list and out of the counts
> is useful.
> 
> For this particular case what problem did you see with calling attach_pid
> with PIDTYPE_PID on init_struct_pid?

On boot up, the CPU 0 idle task is attached to init_struct_pid, and not 
the others. If you do a "attach_pid" on the next idle task that is created, 
it will become the attched process, bumping off CPU 0's idle task from the 
init_struct_pid.

When doing the code you suggested, I end up with only marking the last 
idle task to be created.

-- Steve

