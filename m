Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZKJJrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZKJJrY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 04:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751271AbZKJJrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 04:47:24 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:45202 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZKJJrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 04:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cljucM4SfKgAzBteMx6zYACD9KbebMBbpJ3z8/szbwPzHcxAw4l8ti0ApQAWmxHSHY
         kWWkdnA/MX1ulU9+Uw4iv4VWAK3rEXfP12op918GVOjDfoI2rFFJIw0Ls6jn8DJE7a5/
         PehpLrs1WpAqXD9D4/Vif0WvjSHIDeCtjvfWo=
Date: Tue, 10 Nov 2009 10:47:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/4] perf/core: Small event scheduling changes
Message-ID: <20091110094730.GC5255@nowhere>
References: <1257711206-12243-1-git-send-email-fweisbec@gmail.com> <20091110051321.GE7897@elte.hu> <20091110094143.GB5255@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091110094143.GB5255@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 10:41:45AM +0100, Frederic Weisbecker wrote:
> Thanks.
> 
> With this draft, it makes the pinned priority more consistent
> with its purpose but it doesn't yet bring the full pinned over
> flexible priority determinism.
> 
> It does apply the priority in tick time, while we round robin.
> I did that there first so that it covers most of the events
> rescheduling actions and also it doesn't bring much more
> overhead over the previous layout (in theory), it just changes
> the order.
> 
> I'll also try to expand the priority constraint each time we
> sched in a task: when we schedule a new task that belongs to
> a new context, we don't schedule out/in the cpu context but
> that will be needed if we want the full priority determinism.


To lower the overhead at non-tick time, we could even just reschedule
the cpu flexible events. Anyway...



> 
> Anyway, I'll do that progressively.
> 
> 	Frederic.
> 

