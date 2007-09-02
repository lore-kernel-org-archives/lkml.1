Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbXIBXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbXIBXKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 19:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752910AbXIBXKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 19:10:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:7983 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbXIBXKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 19:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dWQAczlh/emUX0w/E/nbY+dg34nxNSccrsa6ULLXmUgpfrGmIXrJx4IkglLpoEVx01D1dOMnmC+nLcazqxN1+++k2lSR9vBabDAZypGjgJUGythQ+KuRmdvsoWk51AuymdckfAYJU+CmxWQ7uvEYsBSjr4KY4Qn4dxlCTtuahCU=
Message-ID: <5a4c581d0709021610s113f8d15kb723bbd36343f95@mail.gmail.com>
Date: Mon, 3 Sep 2007 01:10:09 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Satyam Sharma" <satyam@infradead.org>
Subject: Re: Hang in 2.6.23-rc5
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>, "FD Cami" <francois.cami@free.fr>,
       "charles gagalac" <charles.gagalac@gmail.com>,
       "daryll q" <daryll_26m@yahoo.com.ph>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <994260.18490.qm@web57301.mail.re1.yahoo.com>
	 <6cf66ee10709021205u7d57b93fv777f414dbba4373f@mail.gmail.com>
	 <5a4c581d0709021338s1e9e0dc0md490a032781b60e8@mail.gmail.com>
	 <20070902232939.f2c8acbb.francois.cami@free.fr>
	 <20070902214631.GA1892@martell.zuzino.mipt.ru>
	 <alpine.LFD.0.999.0709030411510.31154@enigma.security.iitk.ac.in>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/3/07, Satyam Sharma <satyam@infradead.org> wrote:
>
>
> On Mon, 3 Sep 2007, Alexey Dobriyan wrote:
> >
> > Try this from net-2.6 tree:
> >
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -560,7 +560,7 @@ static u32 tcp_rto_min(struct sock *sk)
> >       struct dst_entry *dst = __sk_dst_get(sk);
> >       u32 rto_min = TCP_RTO_MIN;
> >
> > -     if (dst_metric_locked(dst, RTAX_RTO_MIN))
> > +     if (dst && dst_metric_locked(dst, RTAX_RTO_MIN))
> >               rto_min = dst->metrics[RTAX_RTO_MIN-1];
> >       return rto_min;
> >  }
>
> That's my impression as well. That's way too core/busy a codepath to have
> a bug in. As I said earlier, almost anybody testing -rc5 is sure to hit
> this within a few hours (probably less) -- sad, it greatly erodes from the
> usefulness of -rc5 as a release candidate.
>

Well - when my box locked up I was also doing a 300MB scp
 through my ipw2200 wireless interface. But I did another today
 and nothing bad happened.

In another email someone mentioned /var/log/messages - no,
 that was totally void of anything peculiar, despite the fact that
 I rebooted via Alt-SysRq T / P / S / U / B (this last did reboot
 the box). Upon restart however no, nothing in /var/log/messages.
Didn't think it was the case to set up netconsole - only one
 occurrence AND with VMWare modules loaded...

I will apply the above fix and will post again in case the hang
 issue pops up again. Thanks, ciao,

--alessandro

 "I can't believe you if I can't hear you"

   (Editors, 'Smokers Outside The Hospital Doors')
