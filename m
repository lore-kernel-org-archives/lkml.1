Return-Path: <linux-kernel-owner+w=401wt.eu-S1755235AbZLHH5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235AbZLHH5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 02:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754362AbZLHH5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 02:57:30 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:58366 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbZLHH53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 02:57:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XVLv7AIh8/ZDX5o0HteNTkLUGYvmBU6TW6uLErvWstYWBghf80lOqtg7n6sRSEwn/A
         gFj2Sw7n2vPexAAZaZ3HISlh6yqlyf2JiYwH8BO+8k9Fln6bs7MNF5FVTr1VbxVGqL+a
         EVACdjTKrN9CMDw+SiFbq2bwBVA/WCX1PpkH4=
Date: Tue, 8 Dec 2009 08:57:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Li Zefan <lizf@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 02/13] tracing: Extract calls to
	trace_define_common_fields()
Message-ID: <20091208075731.GC4989@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com> <4B1DC49C.8000107@cn.fujitsu.com> <4B1DE5D4.4070805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1DE5D4.4070805@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 08, 2009 at 01:36:20PM +0800, Lai Jiangshan wrote:
> Li Zefan wrote:
> > Call trace_define_common_fields() in event_create_dir() only.
> > 
> >    text    data     bss     dec     hex filename
> > 5346802 1961864 7103260 14411926         dbe896 vmlinux.o.old
> > 5345151 1961864 7103260 14410275         dbe223 vmlinux.o
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> I think this is a urgent patch for mainline.
> 
> I have found a regression at trace_kprobe, and I'm lucky to find that this
> patch can also fix this regression.
> 
> 
> > --- a/kernel/trace/trace_kprobe.c
> > +++ b/kernel/trace/trace_kprobe.c
> > @@ -1113,10 +1113,6 @@ static int kprobe_event_define_fields(struct ftrace_event_call *event_call)
> >  	struct kprobe_trace_entry field;
> >  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
> >  
> > -	ret = trace_define_common_fields(event_call);
> > -	if (!ret)
> > -		return ret;
> > -
> >  	DEFINE_FIELD(unsigned long, ip, FIELD_STRING_IP, 0);
> >  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
> >  	/* Set argument names as fields */
> > @@ -1131,10 +1127,6 @@ static int kretprobe_event_define_fields(struct ftrace_event_call *event_call)
> >  	struct kretprobe_trace_entry field;
> >  	struct trace_probe *tp = (struct trace_probe *)event_call->data;
> >  
> > -	ret = trace_define_common_fields(event_call);
> > -	if (!ret)
> > -		return ret;
> > -
> >  	DEFINE_FIELD(unsigned long, func, FIELD_STRING_FUNC, 0);
> >  	DEFINE_FIELD(unsigned long, ret_ip, FIELD_STRING_RETIP, 0);
> >  	DEFINE_FIELD(int, nargs, FIELD_STRING_NARGS, 1);
> 
> "if (!ret)" is wrong. trace_define_common_fields() returns zero when success.
> So "unsigned long, func", "unsigned long, ret_ip" ...etc are NOT "defined"
> and filters can not be applied for trace_kprobe.
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 


Oh right!

Ok, I'm queueing this one for the tracing fixes.
Thanks!

