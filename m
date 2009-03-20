Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbZCTIUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbZCTIUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZCTIU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:20:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:55282 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZCTIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:20:24 -0400
Subject: Re: [patch] fix uml slowness caused by ptrace preemption bug on
 host
From: Peter Zijlstra <peterz@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: roland@redhat.com, efault@gmx.de, rjw@sisk.pl, jdike@addtoit.com,
       mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu>
References: <E1LkQeU-00020Z-Be@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 20 Mar 2009 09:19:29 +0100
Message-Id: <1237537169.24626.29.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-19 at 23:23 +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> This patch fixes bug #12208.
> 
> This turned out to be not a scheduler regression, but an already
> existing problem in ptrace being triggered by subtle scheduler
> changes.
> 
> The problem is this:
> 
>  - task A is ptracing task B
>  - task B stops on a trace event
>  - task A is woken up and preempts task B
>  - task A calls ptrace on task B, which does ptrace_check_attach()
>  - this calls wait_task_inactive(), which sees that task B is still on the runq
>  - task A goes to sleep for a jiffy
>  - ...
> 
> Since UML does lots of the above sequences, those jiffies quickly add
> up to make it slow as hell.
> 
> This patch solves this by not scheduling on preempt_enable() after
> ptrace_stop() has woken up the tracer.

Nice,.. however did you find this?

Ingo is looking at changing wait_task_inactive() to not be quite so
stupid. I'll let him respond with more details when he's done poking at
the code :-)


