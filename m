Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXCSVcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXCSVcS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965028AbXCSVcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:32:18 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57559 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964988AbXCSVcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:32:17 -0400
Date: Mon, 19 Mar 2007 14:30:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Eric Dumazet <dada1@cosmosbay.com>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, take3] getrusage() : Fill ru_inblock and ru_oublock
 fields if possible
Message-Id: <20070319143058.f2a4af1b.akpm@linux-foundation.org>
In-Reply-To: <20070319143723.GA152@tv-sign.ru>
References: <20070319130213.bb387150.dada1@cosmosbay.com>
	<20070319143723.GA152@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007 17:37:23 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

> On 03/19, Eric Dumazet wrote:
> >
> > [...snip...]
> >  			do {
> >  				utime = cputime_add(utime, t->utime);
> > @@ -2040,6 +2045,8 @@ static void k_getrusage(struct task_stru
> >  				r->ru_nivcsw += t->nivcsw;
> >  				r->ru_minflt += t->min_flt;
> >  				r->ru_majflt += t->maj_flt;
> > +				r->ru_inblock += task_io_get_inblock(t);
> > +				r->ru_oublock += task_io_get_oublock(t);
> >  				t = next_thread(t);
> >  			} while (t != p);
> 
> (offtopic)
> 
> We are reading u64 read_bytes/write_bytes which could be updated asynchronously.
> /proc/pid/io does the same.

Yup, as noted in the Documentation/filesystems/proc.txt documentation ;)

> Of course, I don't blame this patch, just a stupid question: can we do something?
> I guess not.

Yes, I find it hard to justify the additional expense which fixing this
would cause.

Which probably means that someone will find it terribly terribly important
and we have to go and do something horrid anyway.  Sigh.

