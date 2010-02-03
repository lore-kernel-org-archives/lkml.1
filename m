Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab0BCWNO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 17:13:14 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:44251 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab0BCWNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 17:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cPAsxkSzw9ZyxZ8S8gBRhoCCgzpgnZZZXMUCah1TzqBLJAyMTQ6MoBJg4SXZUygiJT
         RC4HhzvksvXg12T1kvBUqT8ZasR3y5loOSsqPVt24DM4BmMPJ9fgUnLjSStbMWWtq92Z
         rCLMkYTPABpd77Veu/YeEKi48ZobyJFGwN91o=
Date: Wed, 3 Feb 2010 23:13:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [RFC GIT PULL] perf/trace/lock optimization/scalability
	improvements
Message-ID: <20100203221303.GE5068@nowhere>
References: <1265188475-23509-1-git-send-regression-fweisbec@gmail.com> <20100203102540.GQ5733@kernel.dk> <20100203205009.GB5068@nowhere> <20100203212143.GW5733@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203212143.GW5733@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:21:43PM +0100, Jens Axboe wrote:
> On Wed, Feb 03 2010, Frederic Weisbecker wrote:
> > > So while this is orders of magnitude better than the previous patchset,
> > > it's still not anywhere near lean. But I expect you know that, just
> > > consider this a 'I tested it and this is what happened' report :-)
> > 
> > 
> > Ok, thanks a lot, the fact you can test on a 64 threads box is critically
> > helpful.
> 
> My pleasure, I'd love to have a fast and functional perf lockstat. If my
> testing helps getting there, consider me signed up :-)



Great :)


> > I also wonder what happens after this patch applied:
> > 
> > diff --git a/kernel/perf_event.c b/kernel/perf_event.c
> > index 98fd360..254b3d4 100644
> > --- a/kernel/perf_event.c
> > +++ b/kernel/perf_event.c
> > @@ -3094,7 +3094,8 @@ static u32 perf_event_tid(struct perf_event *event, struct task_struct *p)
> >         if (event->parent)
> >                 event = event->parent;
> >  
> > -       return task_pid_nr_ns(p, event->ns);
> > +       return p->pid;
> >  }
> > 
> > In my box it has increased the speed from 2x this patchset.
> 
> Cool, I'll give that a spin in the morning, the box is off atm.


Thanks a lot!

