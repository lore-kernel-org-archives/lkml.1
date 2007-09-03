Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXICHIC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXICHIC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 03:08:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbXICHHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 03:07:52 -0400
Received: from lilly.ping.de ([83.97.42.2]:1409 "HELO lilly.ping.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751753AbXICHHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 03:07:51 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2007 03:07:51 EDT
Date: Mon, 3 Sep 2007 08:39:04 +0200
From: Patrick Mau <mau@oscar.ping.de>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hang in 2.6.23-rc5
Message-ID: <20070903063904.GA1935@oscar.prima.de>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com> <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com> <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com> <20070902232939.f2c8acbb.francois.cami@free.fr> <20070902214631.GA1892@martell.zuzino.mipt.ru> <alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 04:15:01AM +0530, Satyam Sharma wrote:
> On Mon, 3 Sep 2007, Alexey Dobriyan wrote:
> > 
> > Try this from net-2.6 tree:
> > 
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
> >  	struct dst_entry *dst = __sk_dst_get(sk);
> >  	u32 rto_min = TCP_RTO_MIN;
> >  
> > -	if (dst_metric_locked(dst, RTAX_RTO_MIN))
> > +	if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
> >  		rto_min = dst->metrics[RTAX_RTO_MIN-1];
> >  	return rto_min;
> >  }
> 
> That's my impression as well. That's way too core/busy a codepath to have
> a bug in. As I said earlier, almost anybody testing -rc5 is sure to hit
> this within a few hours (probably less) -- sad, it greatly erodes from the
> usefulness of -rc5 as a release candidate.

The above patch also fixed my problems using NFS mounted home directories.

I already applied it yesterday without giving any feedback, so I just
thought I should comment.

In addition I totally agree with Satyam's comment above: either
anybody is testing rc's these days, or people simply stopped reporting.

My concern is that we have to live with a git tree that has this
problem, because core developers are unavailable and nobody has the
authority to commit this fix. (That was already posted before).

I am not voting for public commit rights and personally I don't want
them anyway. It's just my observation that nothing really happens
whenever a point release is only a few days away.

Maybe most people believe that they have to wait for the 2.6.24
cycly to start before they join the discussion again ...

Patrick

