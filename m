Return-Path: <linux-kernel-owner+w=401wt.eu-S1753571AbZLHIQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571AbZLHIQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbZLHIQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:16:56 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:47170 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752364AbZLHIQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:16:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iX8JYQjPNJwMQO+FkIoOUGLC6Rz0COvybCfrdPzWJwg3IgynED5rBnHoh4Mgkw8QHZ
         Yo3771vgQAEiHC0+GeHE22qLO3TFVJXssKJcMGto6XC0Jmi3qt7hIacsSi+d78OFkCT7
         FzhBAhn077pg0J9mOnDlMVfvUmSVZpN/kdiiE=
Date: Tue, 8 Dec 2009 09:16:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 02/13] tracing: Extract calls to
	trace_define_common_fields()
Message-ID: <20091208081657.GG4989@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC49C.8000107@cn.fujitsu.com> <4B1DE5D4.4070805@cn.fujitsu.com> <20091208075731.GC4989@nowhere> <4B1E086E.7040001@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1E086E.7040001@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 04:03:58PM +0800, Li Zefan wrote:
> >>> --- a/kernel/trace/trace_kprobe.c
> >>> +++ b/kernel/trace/trace_kprobe.c
> >>> @@ -1113,10 +1113,6 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
> >>>  	struct kprobe_trace_entry field;
> >>>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
> >>>  
> >>> -	ret = trace_define_common_fields(event_call);
> >>> -	if (!ret)
> >>> -		return ret;
> >>> -
> >>>  	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
> >>>  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
> >>>  	/* Set argument names as fields */
> >>> @@ -1131,10 +1127,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
> >>>  	struct kretprobe_trace_entry field;
> >>>  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
> >>>  
> >>> -	ret = trace_define_common_fields(event_call);
> >>> -	if (!ret)
> >>> -		return ret;
> >>> -
> >>>  	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
> >>>  	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
> >>>  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
> >> "if (!ret)" is wrong. trace_define_common_fields() returns zero when success.
> >> So "unsigned long, func", "unsigned long, ret_ip" ...etc are NOT "defined"
> >> and filters can not be applied for trace_kprobe.
> >>
> >> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> >>
> > 
> > Oh right!
> > 
> > Ok, I'm queueing this one for the tracing fixes.
> > Thanks!
> > 
> 
> This patch has dependency on the previous patch..So can you queue
> all other patches and send a pull request to Ingo? We're still
> in the early merge window, so those patches should be fine for
> .33.
> 
> And as this patch fixes a bug "acidentally", the changelog
> needs a bit revision.


The problem is that we can't know in advance Linus will take
a second round of tracing features in this merge window.

I'd rather be careful and keep separating tracing fixes and
tracing features.

I'm preparing a separate fix.

