Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbZKKV6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbZKKV6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:58:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759433AbZKKV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:58:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46809 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759373AbZKKV6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:58:08 -0500
Subject: Re: [PATCH] ftrace: return error instead of 12 bytes read
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roel Kluin <roel.kluin@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       ingo <mingo@elte.hu>, Andy Whitcroft <apw@shadowen.org>
In-Reply-To: <20091111134730.a0da9e38.akpm@linux-foundation.org>
References: <4AFB2C0B.50605@gmail.com>
	 <20091111134730.a0da9e38.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 11 Nov 2009 16:58:12 -0500
Message-Id: <1257976692.22249.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-11 at 13:47 -0800, Andrew Morton wrote:
> On Wed, 11 Nov 2009 22:26:35 +0100
> Roel Kluin <roel.kluin@gmail.com> wrote:
> 
> > A negative error value is required: now we cannot
> > distinguish ENOMEM from a valid read of 12 bytes.
> > 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> >  kernel/trace/trace.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index b20d3ec..03c7fd5 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -3730,7 +3730,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
> >  
> >  	s = kmalloc(sizeof(*s), GFP_KERNEL);
> >  	if (!s)
> > -		return ENOMEM;
> > +		return -ENOMEM;
> >  
> >  	trace_seq_init(s);
> >  
> 
> lol, there we go again.
> 
> Andy, can we have a checkpatch rule please?

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


