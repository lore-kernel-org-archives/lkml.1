Return-Path: <linux-kernel-owner+w=401wt.eu-S1752581AbXCSLNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbXCSLNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 07:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbXCSLNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 07:13:22 -0400
Received: from pfx2.jmh.fr ([194.153.89.55]:43732 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbXCSLNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 07:13:22 -0400
From: Eric Dumazet <dada1@cosmosbay.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH, take2] getrusage() : Fill ru_inblock and ru_oublock fields if possible
Date: Mon, 19 Mar 2007 12:13:19 +0100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200703191139.40281.dada1@cosmosbay.com> <20070319105358.GA152@tv-sign.ru>
In-Reply-To: <20070319105358.GA152@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703191213.19652.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 19 March 2007 11:53, Oleg Nesterov wrote:
> On 03/19, Eric Dumazet wrote:
> > +static inline unsigned long task_io_get_inblock(const struct task_struct
> > *p) +{
> > +	return p->ioac.read_bytes >> 9;
> > +}
> >
> > [...snip...]
> >
> > @@ -2021,6 +2022,8 @@ static void k_getrusage(struct task_stru
> >  			r->ru_nivcsw = p->signal->cnivcsw;
> >  			r->ru_minflt = p->signal->cmin_flt;
> >  			r->ru_majflt = p->signal->cmaj_flt;
> > +			r->ru_inblock = p->signal->cinblock;
> > +			r->ru_oublock = p->signal->coublock;
> >
> >  			if (who == RUSAGE_CHILDREN)
> >  				break;
> > @@ -2032,6 +2035,8 @@ static void k_getrusage(struct task_stru
> >  			r->ru_nivcsw += p->signal->nivcsw;
> >  			r->ru_minflt += p->signal->min_flt;
> >  			r->ru_majflt += p->signal->maj_flt;
> > +			r->ru_inblock += task_io_get_inblock(p->signal);
>
> p->signal is "struct signal_struct *", not "struct task_struct *" as
> task_io_get_inblock() expects ?

Me wonder how I can be sooo stupid this morning !

I submit 'take3' after some coffee... thank you Oleg

(BTW, I am going to switch from kmail to sylpheed because this damn mailer is 
too clever for me)

