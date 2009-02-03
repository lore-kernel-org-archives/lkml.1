Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZBCMdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZBCMdy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 07:33:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbZBCMdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 07:33:42 -0500
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:45075 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752407AbZBCMdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 07:33:41 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=IVrIwjwvY3+DDvbdME3SSCmNhXpZrpaIA1+F6Y4qoqrVrRO432WBaLcM/tPFXv7VFAwB4IEiCyjonOmFttR+d7gteVwmOY6G2NZ3if2dTCjWdZ3BwGBH1q1+FW4TnVQhIjZ3jCw28f0osvU+2R5DO9KtsO0wSVpIkpfLi4A0ur8=  ;
X-YMail-OSG: WAAeYQkVM1lwnDB8XsVfT_peR_e_0YiZe5NZPuaN9nznRnAE8eLwNqLavExNpMJWNgTuqzK06fr3nM.2N43buCZqlNJ16NIZM0UBNqtP8ek5FTJmlCvfIW6uPju3fVhLCLd4mr1e0VQaOgYmwlbCcItZnnwkt_If94geCoUg08LTWFbgfA_leI97v55SAQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Date: Tue, 3 Feb 2009 23:33:12 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Evgeniy Polyakov <zbr@ioremap.net>, david@lang.hm,
       Jarek Poplawski <jarkao2@gmail.com>, David Miller <davem@davemloft.net>,
       w@1wt.eu, dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
References: <20090202080855.GA4129@ff.dom.local> <20090203121219.GB22427@ioremap.net> <20090203121808.GA9218@gondor.apana.org.au>
In-Reply-To: <20090203121808.GA9218@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902032333.15525.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 February 2009 23:18:08 Herbert Xu wrote:
> On Tue, Feb 03, 2009 at 03:12:19PM +0300, Evgeniy Polyakov wrote:
> > It is a solution, but I think it will behave noticebly worse than
> > with decresed MTU.
>
> Not necessarily.  Remember GSO/GRO in essence are just hacks to
> get around the fact that we can't increase the MTU to where we
> want it to be.  MTU reduces the cost over the entire path while
> GRO/GSO only do so for the sender and the receiver.
>
> In other words when given the choice between a larger MTU with
> copying or GRO, the larger MTU will probably win anyway as it's
> optimising the entire path rather than just the receiver.
>
> > That's the main point: how to deal with broken hardware? I think (but
> > have no strong numbers though) that having 6 packets with 1500 MTU
> > combined into GRO/LRO frame will be processed way faster than copying 9k
> > MTU into 3 pages and process single skb.
>
> Please note that with my scheme, you'd only start copying if you
> can't allocate a linear skb.  So if memory fragmentation doesn't
> happen then there is no copying at all.

This sounds like a really nice idea (to the layman)!

