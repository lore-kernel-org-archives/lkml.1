Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbZCXQE5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbZCXQE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 12:04:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbZCXQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 12:04:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40417 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759360AbZCXQEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 12:04:45 -0400
Date: Tue, 24 Mar 2009 12:04:43 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Li Zefan <lizf@cn.fujitsu.com>, Jens Axboe <jens.axboe@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] blktrace: print human-readable act_mask
In-Reply-To: <20090324155609.GA10365@elte.hu>
Message-ID: <alpine.DEB.2.00.0903241202440.22830@gandalf.stny.rr.com>
References: <49C893FC.9080905@cn.fujitsu.com> <49C89488.4030604@cn.fujitsu.com> <alpine.DEB.2.00.0903241148240.22830@gandalf.stny.rr.com> <20090324155609.GA10365@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Tue, 24 Mar 2009, Ingo Molnar wrote:

> 
> * Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > 
> > 
> > On Tue, 24 Mar 2009, Li Zefan wrote:
> > >  
> > > +static ssize_t blk_trace_mask2str(char *buf, int mask)

> > >  	else if (attr == &dev_attr_act_mask)
> > > -		ret = sprintf(buf, "%#x\n", q->blk_trace->act_mask);
> > > +		ret = blk_trace_mask2str(buf, q->blk_trace->act_mask);


> > > -			value = blk_str2act_mask(buf);
> > > -			if (value < 0)
> > > +			value = blk_trace_str2mask(buf);
> > 
> > Hmm, does this compile? Doesn't blk_trace_str2mask need two parameters?
> 
> No, it needs one parameter.

I'm really confused now. The prototype for blk_trace_str2mask has 
two parameters. It is used with two parameters above, but then it is used 
here with only one parameter. The blk_str2act_mask may have one, and that 
is what is replaced.

What am I missing?

-- Steve

