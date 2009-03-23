Return-Path: <linux-kernel-owner+w=401wt.eu-S1760559AbZCWTrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760559AbZCWTrX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757885AbZCWTrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:47:13 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:56642 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923AbZCWTrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:47:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JqpJlSoQ30BPRDMj83TTeru56zVSZSI8tFaSxiJJ2Y5+3QIKRSUL4fDj7eG/vKyA3b
         +jTI6U0oJbuvdE+ZOglmYvB+roVFBlNGB7SQLgM/dZf4m1ODFapUmvHPsGVGKg+jaxcs
         Y2ZlAqPX3IkQnpG4bn4Wlpze9hsClSZgoV28I=
Date: Mon, 23 Mar 2009 20:47:07 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tracing/ftrace: check if debugfs is registered
	before creating files
Message-ID: <20090323194705.GE5988@nowhere>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com> <1237759847-21025-3-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0903231517410.3578@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0903231517410.3578@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 03:18:49PM -0400, Steven Rostedt wrote:
> 
> On Sun, 22 Mar 2009, Frederic Weisbecker wrote:
> 
> > Impact: fix a crash with ftrace={nop,boot} parameter
> > 
> > If the nop or initcall tracers are launched as boot tracers,
> > they will attempt to create their option directory and files.
> > But these tracers are registered very early and then assigned
> > as "boot tracers" very early if asked to.
> > 
> > Since they do this before debugfs has been registered (core initcall),
> > a crash is triggered.
> > 
> > Another early tracers could also come later. So we fix it by
> > checking if debugfs is initialized before creating the root
> > tracing directory.
> > 
> > Cc: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/trace/trace.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index ace685c..f0e1337 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3513,6 +3513,9 @@ struct dentry *tracing_init_dentry(void)
> >  	if (d_tracer)
> >  		return d_tracer;
> >  
> > +	if (!debugfs_initialized())
> > +		return NULL;
> > +
> >  	d_tracer = debugfs_create_dir("tracing", NULL);
> >  
> 
> Hmm, those tracers should separate out the debugfs code, and put it into 
> a fs_initcall(), where debugfs should already initialized.
> 
> -- Steve
> 

Indeed, I lacked a bit of imagination here :-)

Thanks!

