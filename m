Return-Path: <linux-kernel-owner+w=401wt.eu-S1758832AbXIBWcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832AbXIBWcI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 18:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753022AbXIBWb4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 18:31:56 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42630 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbXIBWbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 18:31:55 -0400
Date: Mon, 3 Sep 2007 04:15:01 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: FD Cami <francois.cami@free.fr>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       charles gagalac <charles.gagalac@gmail.com>,
       daryll q <daryll_26m@yahoo.com.ph>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Hang in 2.6.23-rc5
In-Reply-To: <20070902214631.GA1892@martell.zuzino.mipt.ru>
Message-ID: <alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
 <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
 <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
 <20070902232939.f2c8acbb.francois.cami@free.fr>
 <20070902214631.GA1892@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Sep 2007, Alexey Dobriyan wrote:
> 
> Try this from net-2.6 tree:
> 
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
>  	struct dst_entry *dst = __sk_dst_get(sk);
>  	u32 rto_min = TCP_RTO_MIN;
>  
> -	if (dst_metric_locked(dst, RTAX_RTO_MIN))
> +	if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
>  		rto_min = dst->metrics[RTAX_RTO_MIN-1];
>  	return rto_min;
>  }

That's my impression as well. That's way too core/busy a codepath to have
a bug in. As I said earlier, almost anybody testing -rc5 is sure to hit
this within a few hours (probably less) -- sad, it greatly erodes from the
usefulness of -rc5 as a release candidate.
