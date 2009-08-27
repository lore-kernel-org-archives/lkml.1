Return-Path: <linux-kernel-owner+w=401wt.eu-S1752721AbZH0NsO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbZH0NsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 09:48:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752676AbZH0NsO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 09:48:14 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:36624 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZH0NsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 09:48:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Fbs5/DkTyT6JugWXQ5UXatPhtALz9jqf2Wk/Gk5kQBi6FMLKbyZOGA41zpOsWE2cwt
         E6KKDzTrtP+CpQKcQRvrF/5bZBC2MH5HRgnEQetcJqqaEdmInbKfaysdCQDivwJpPiH9
         gfqVtqEofmFJe0eXWIjh1f6GdI2neusF2g2tA=
Date: Thu, 27 Aug 2009 15:48:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Przemys??aw Pawe??czyk <przemyslaw@pawelczyk.it>,
       Roland McGrath <roland@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [PATCH 08/18] tracing: Add kprobe-based event tracer
Message-ID: <20090827134800.GC6058@nowhere>
References: <1251340337-5640-1-git-send-email-fweisbec@gmail.com> <1251340337-5640-9-git-send-email-fweisbec@gmail.com> <20090827073139.GB2131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827073139.GB2131@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 09:31:39AM +0200, Ingo Molnar wrote:
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > From: Masami Hiramatsu <mhiramat@redhat.com>
> > 
> > Add kprobes-based event tracer on ftrace.
> > 
> > This tracer is similar to the events tracer which is based on 
> > Tracepoint infrastructure. Instead of Tracepoint, this tracer is 
> > based on kprobes (kprobe and kretprobe). It probes anywhere where 
> > kprobes can probe(this
> >  means, all functions body except for __kprobes functions).
> > 
> > Similar to the events tracer, this tracer doesn't need to be 
> > activated via current_tracer, instead of that, just set probe 
> > points via /sys/kernel/debug/tracing/kprobe_events. And you can 
> > set filters on each probe events via 
> > /sys/kernel/debug/tracing/events/kprobes/<EVENT>/filter.
> 
> ok, one observation here: this should seemlessly merge into 
> /debug/tracing/events/ and provide a record format descriptor in 
> 'format' to allow the automated fetching of the results of the 
> probe. The PERF_SAMPLE_RAW gateway should work as well.
>  
> That way tooling that knows about /debug/tracing/events/ will 
> automatically work with kprobes events as well. We can profile based 
> on kprobes, etc. etc.
> 
> The _setting_ of the probe is still a separate channel - but if 
> existing installed probes are merged into existing tooling that's a 
> big step forward in terms of utility.
> 
> 	Ingo


It does already :)

But I've split out this patch that initially embeded the documentation.
If you look at the 9/10 patch, you can see how look like the format
files for kprobes.

