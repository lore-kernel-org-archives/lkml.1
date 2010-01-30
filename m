Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748Ab0A3WHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab0A3WHv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 17:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275Ab0A3WHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 17:07:50 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:33925 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0A3WHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 17:07:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OnpmRhWfaDxqTPX9DbjvB/sUbDexJqEt6YzR51X9B/rP/jb5YlmbjtvPZrzFUubzRp
         AcAWa9j7KQ/FQZSUQ84iISR3aWvC3ZgyUquF69GBfUSDjG5V9qomRnTt1OfQP50eiiLQ
         md6eF116tFQSIycaqmu328kOQCfLpvzjC9Qhc=
Date: Sat, 30 Jan 2010 23:07:46 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] tracing: Change trace_seq to use separate buffer
Message-ID: <20100130220745.GK5675@nowhere>
References: <4B556078.7000004@cn.fujitsu.com> <20100120184046.GA6194@nowhere> <4B5E607F.2040204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E607F.2040204@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 11:24:47AM +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Tue, Jan 19, 2010 at 03:34:16PM +0800, Lai Jiangshan wrote:
> >> @@ -3124,6 +3126,8 @@ waitagain:
> >>  	if (cnt >= PAGE_SIZE)
> >>  		cnt = PAGE_SIZE - 1;
> >>  
> >> +	trace_seq_reset(&iter->seq);
> >> +
> > 
> > 
> > 
> > So we actually add a trace_seq_reset here.
> > This should have been in the first patch, which drops
> > the memset, and eventually modified here, just to avoid
> > breaking things in the middle of a patchset.
> > 
> > Things were already broken though before the memset dropping
> > patch though in other ways, so it's not that important I guess...
> > 
> > 
> 
> There is no trace_seq_reset() before this patch applied.
> trace_seq_init() in the first patch, has already reset it.



We have trace_seq_init() in the beginning of tracing_read_pipe()
but not in case we loop in waitagain.

In the first patch you've removed this:

	memset(&iter->seq, 0,
	       sizeof(struct trace_iterator) -
	       offsetof(struct trace_iterator, seq));

Which was a reset in waitagain.

And you re-add this reset in this patch, while it should have
been in the first one?

May be I miss something, that's not important really, things
were broken with the memset.

