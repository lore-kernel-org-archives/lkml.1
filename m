Return-Path: <linux-kernel-owner+w=401wt.eu-S1752637AbXIHJfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbXIHJfF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 05:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXIHJey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 05:34:54 -0400
Received: from postfix1-g20.free.fr ([212.27.60.42]:35582 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbXIHJex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 05:34:53 -0400
Date: Sat, 8 Sep 2007 11:37:46 +0200
From: FD Cami <francois.cami@free.fr>
To: Satyam Sharma <satyam@infradead.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       charles gagalac <charles.gagalac@gmail.com>,
       daryll q <daryll_26m@yahoo.com.ph>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hang in 2.6.23-rc5
Message-Id: <20070908113746.d4fceb87.francois.cami@free.fr>
In-Reply-To: <alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
	<6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
	<5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
	<20070902232939.f2c8acbb.francois.cami@free.fr>
	<20070902214631.GA1892@martell.zuzino.mipt.ru>
	<alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
X-Mailer: Sylpheed 2.4.4 (GTK+ 2.10.14; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Sep 2007 04:15:01 +0530 (IST)
Satyam Sharma <satyam@infradead.org> wrote:

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
> That's my impression as well. That's way too core/busy a codepath to
> have a bug in. As I said earlier, almost anybody testing -rc5 is sure
> to hit this within a few hours (probably less) -- sad, it greatly
> erodes from the usefulness of -rc5 as a release candidate.

For the record, I haven't been able to reproduce the lockup with this
patch.

Cheers

François
