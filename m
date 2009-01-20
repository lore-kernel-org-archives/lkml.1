Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZATKVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZATKVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 05:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZATKVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 05:21:01 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:11471 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241AbZATKVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 05:21:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u6guEspJItb3n/4SRiDR648uQU6v4ubrrKJC9wqT8Sr3nLYKWWetJtsMSK1eqj8QIW
         C/c7Uu+IEUemxXrMVx/1AhEwzxh76g79Z7vb2+4HoXnLmkRk2uX/cD/GCDJ7ey2johnw
         fr6/dFxlNEOvZpTrMp0wwm2r+4VB+KcO6sWYM=
Date: Tue, 20 Jan 2009 10:20:53 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au, w@1wt.eu,
       dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Message-ID: <20090120102053.GA17004@ff.dom.local>
References: <20090114.012919.117682429.davem@davemloft.net> <20090115230331.GB1123@1wt.eu> <20090115231934.GA8328@gondor.apana.org.au> <20090115.152608.89323697.davem@davemloft.net> <20090120083726.GA13806@ff.dom.local> <20090120093352.GB13806@ff.dom.local> <20090120100043.GA9167@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120100043.GA9167@ioremap.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 01:00:43PM +0300, Evgeniy Polyakov wrote:
> Hi Jarek.

Hi Evgeniy.
...
> > diff --git a/include/net/sock.h b/include/net/sock.h
> > index 5a3a151..4ded741 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -190,6 +190,8 @@ struct sock_common {
> >    *	@sk_user_data: RPC layer private data
> >    *	@sk_sndmsg_page: cached page for sendmsg
> >    *	@sk_sndmsg_off: cached offset for sendmsg
> > +  *	@sk_splice_page: cached page for splice
> > +  *	@sk_splice_off: cached offset for splice
> 
> Ugh, increase every socket by 16 bytes... Does TCP one still fit the
> page?

Good question! Alas I can't check this soon, but if it's really like
this, of course this needs some better idea and rework. (BTW, I'd like
to prevent here as much as possible some strange activities like 1
byte (payload) packets getting full pages without any accounting.)

Thanks,
Jarek P.
