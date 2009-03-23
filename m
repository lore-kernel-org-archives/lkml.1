Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbZCWIc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbZCWIc5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757835AbZCWIby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:31:54 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:49241 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757928AbZCWIbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:31:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SNk4kfErYqx+/hANvnM5vzc2htBK47ANhO41zCwCQgedYutn6RLlSTD8Ti6wyntGWW
         0vcGxJtmgh66D3T2PT9KuIqD9a7InmgTeSXN27ON6bvXiwNKfnkpI1pLatxiRRrtu302
         whKy27hqJXiUBh4aQGK2rqRezBnPpud46zPs8=
Date: Mon, 23 Mar 2009 09:31:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] tracing/events: make the filter files writable
Message-ID: <20090323083146.GB5944@nowhere>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com> <20090323082556.GB18837@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323082556.GB18837@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 09:25:56AM +0100, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > We need the filter files to be writable, the current
> > filter file permissions make are only set readable.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace_events.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> > index 594d78a..19f61dd 100644
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -706,7 +706,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
> >  
> >  	system->preds = NULL;
> >  
> > -	entry = debugfs_create_file("filter", 0444, system->entry, system,
> > +	entry = debugfs_create_file("filter", 0644, system->entry, system,
> >  				    &ftrace_subsystem_filter_fops);
> >  	if (!entry)
> >  		pr_warning("Could not create debugfs "
> > @@ -769,7 +769,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
> >  		}
> >  	}
> >  
> > -	entry = debugfs_create_file("filter", 0444, call->dir, call,
> > +	entry = debugfs_create_file("filter", 0644, call->dir, call,
> 
> Interesting. Yesterday i tried the filter files and they worked - i 
> was able to create a 'comm == bash' filter for example. Does debugfs 
> ignore permissions perhaps?
> 
> 	Ingo


That's the second patch I see this week wich proposes a 444 file supposed
to be writable.
Usually it shouldn't even have been testable, so yes I think there is a
little problem.

