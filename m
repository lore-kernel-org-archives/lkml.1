Return-Path: <linux-kernel-owner+w=401wt.eu-S935370AbZDBGXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935370AbZDBGXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761309AbZDBGW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:22:57 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:20478 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587AbZDBGW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:22:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GSjgM0h6O11PNhSS5lvw8ATdXQ9kP+A+/0PYpXU+dejgWv1rvcvLIEJohXFtmXFvDa
         OQamnkOOA8NpsgNVBmPGlFfcYA/Yz466JYBjg3fCixkrshlWN6yRktLKi2lWJmby/SHr
         xHsZ5Mixywj/Q9xncgZQiBSNm2AbmQVJp3ld4=
Subject: Re: [PATCH] tracing/filters: allow event filters to be set only
 when not tracing
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
In-Reply-To: <20090401122408.GG12966@elte.hu>
References: <1238390546.6368.65.camel@bookworm>
	 <20090401122408.GG12966@elte.hu>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 01:22:51 -0500
Message-Id: <1238653371.6655.48.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 14:24 +0200, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > This patch adds code allowing the event filter to be set only if 
> > there's no active tracing going on.
> 
> > --- a/kernel/trace/trace_events.c
> > +++ b/kernel/trace/trace_events.c
> > @@ -498,6 +498,9 @@ event_filter_write(struct file *filp, const char __user *ubuf, size_t cnt,
> >  	struct filter_pred *pred;
> >  	int err;
> >  
> > +	if (tracing_is_enabled() && (!tracer_is_nop() || call->enabled))
> > +		return -EBUSY;
> 
> hm, but it would be the normal use-case to set filters on the fly. 
> To experiment around with them and shape them until the output is 
> just right. Having to turn the tracer on/off during that seems quite 
> counterproductive to that use-case.
> 

I didn't see anything that could be used to temporarily disable tracing
(tracing_stop() and tracing_start() are 'quick' versions that mostly
just disable recording), so did it this way to avoid adding any overhead
to the filter-checking code.

But anyway, I'll post a new patch shortly that uses rcu and does allow
the filters to be set on the fly.

Tom

> 	Ingo

