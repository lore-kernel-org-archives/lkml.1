Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbZIWVYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbZIWVYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZIWVYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:24:40 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:48239 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZIWVYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:24:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LeAkuFj0n2VPZkMMSeFeuSY3gHXcC1kXjWwlc/d5ys7ZIF/wGoDqJvq8SOZPR1zBPZ
         fN8eDjO9Oh5T4s0pX9zYJ6cBh3kiz1Okhab1jzdqAMoB7xVNusQljK7JIZ9KY2dhyODQ
         8hNip8lXdQIbpEK9DV+kGcqrTKQ1Br6QjOack=
Date: Wed, 23 Sep 2009 23:24:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling
	updates
Message-ID: <20090923212438.GA5190@nowhere>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com> <20090923105252.GA32176@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923105252.GA32176@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 12:52:52PM +0200, Ingo Molnar wrote:
> Would be nice to merge latest -git into this tree and resolve the 
> conflicts:
> 
>  kernel/trace/Makefile
>  kernel/trace/trace.h
>  kernel/trace/trace_event_types.h
>  kernel/trace/trace_export.c
> 
> Then i could pull it into tip:tracing/kprobes for more testing.
> 
> 	Ingo


I've just merged latest upstream tree into it and pushed
that in a new branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	tracing/kprobes-v2

There were several conflicts, not trivial. I hope I haven't missed
something. But it boots well, I've tested a simple kprobe creation
and fetched its events through perf without any problem.

Thanks,
Frederic.

PS: I'd recommend you to define a name when you define a kprobe.
For example if you want to get the first argument of sys_open,
don't create it using:

	p sys_open a0

but rather:

	p:my_probe_name sys_open a0

Otherwise you will get a default kprobe name that doesn't seem
to make perf trace happy (put in my TODO list).

