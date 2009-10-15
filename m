Return-Path: <linux-kernel-owner+w=401wt.eu-S1758221AbZJOMec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221AbZJOMec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 08:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753678AbZJOMec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 08:34:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:23483 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbZJOMeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 08:34:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oj4bpjXwZkjFXGdjxx6mKmk4F4yupL21RLPrKSDo0vnmixprz+pC6wxcPktrp1q0O9
         9HaXK5fKPWX3z9NF5LlD8sv8asW1l/NU0WhbhJ1oEzdai35hGb3q3D3i81ygkg84bxwT
         VLY0NgiKf+gDy6p0tASqkhGGhjHDH1MucGbTU=
Date: Thu, 15 Oct 2009 14:32:40 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] tracing: Fix misuse of strncpy to copy boot params
Message-ID: <20091015123233.GB4960@nowhere>
References: <1255552732-5096-1-git-send-email-fweisbec@gmail.com> <4AD68269.50701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD68269.50701@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 10:01:13AM +0800, Li Zefan wrote:
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 4506826..621d81e 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -131,7 +131,7 @@ static char *default_bootup_tracer;
> >  
> >  static int __init set_ftrace(char *str)
> >  {
> > -	strncpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
> > +	strlcpy(bootup_tracer_buf, str, MAX_TRACER_SIZE);
> 
> Actually using strncpy() here is fine.
> 
> See how the str buf is used:
> 
> int register_tracer(struct tracer *type)
> {
> 	...
> 	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
> 	...
> }



Yeah. I can remove the change for this buffer and send
another pull request.

Thanks.

 
> >  	default_bootup_tracer = bootup_tracer_buf;
> >  	/* We are using ftrace early, expand it */
> >  	ring_buffer_expanded = 1;

