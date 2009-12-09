Return-Path: <linux-kernel-owner+w=401wt.eu-S1755400AbZLIOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbZLIOIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 09:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZLIOIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 09:08:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42766 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbZLIOIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 09:08:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=UbgdT8TlO4YA:10 a=7U3hwN5JcxgA:10 a=EWkde32csmmH9S7bDkkA:9 a=Wp-fNruJdoZ95J_3oHjERubvb2EA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [tip:tracing/urgent] tracing: Add pipe_close interface
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       srostedt@redhat.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
In-Reply-To: <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
References: <tip-c521efd1700a8c0f7ce26f011f5eaecca17fabfa@git.kernel.org>
	 <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 09:08:40 -0500
Message-ID: <1260367720.2146.71.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-09 at 15:35 +0900, KOSAKI Motohiro wrote:

> > diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> > index 874f289..f804b40 100644
> > --- a/kernel/trace/trace.c
> > +++ b/kernel/trace/trace.c
> > @@ -2898,6 +2898,10 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
> >  	else
> >  		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
> >  
> > +
> > +	if (iter->trace->pipe_open)
> > +		iter->trace->pipe_close(iter);
> > +
> 
> What's happen if pipe_close is NULL? Wny following straightforward check
> is wrong?
> I mean the above description explain pipe_close is only useful if plugin
> allocate something at pipe_open. then allowing NULL seems natural.
> 
> 	if (iter->trace->pipe_close)
> 		iter->trace->pipe_close(iter);

Ug, good point (stupid cut & paste should be illegal).

Ingo, I'll fix this up too in the next patch set. Want me to rebase it
or just start with this fix?

-- Steve




