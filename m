Return-Path: <linux-kernel-owner+w=401wt.eu-S1757337AbZANKrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbZANKrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 05:47:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752797AbZANKrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 05:47:24 -0500
Received: from mail-ew0-f17.google.com ([209.85.219.17]:47377 "EHLO
	mail-ew0-f17.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbZANKrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 05:47:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iXftcR55t2kZTcyne92VrlFp/rkhnfqXWoncpHedKLy6wuqjqmZiinKIsg1uDu0yw0
         J+KeYeI6i2BA+mr+Ce4kPDiwBlv7ulHmmfGGhYySkib8gtawi3N7M23RhroffARH+BAn
         +f8CYunNpFI02qzPbi2UC4VFb4zrGd8CLVFyc=
Date: Wed, 14 Jan 2009 10:47:16 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: herbert@gondor.apana.org.au, zbr@ioremap.net, dada1@cosmosbay.com,
       w@1wt.eu, ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090114104716.GE4234@ff.dom.local>
References: <20090114085308.GB4234@ff.dom.local> <20090114.012919.117682429.davem@davemloft.net> <20090114094215.GC4234@ff.dom.local> <20090114.020637.181791518.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114.020637.181791518.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 02:06:37AM -0800, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Wed, 14 Jan 2009 09:42:16 +0000
> 
> > On Wed, Jan 14, 2009 at 01:29:19AM -0800, David Miller wrote:
> > > From: Jarek Poplawski <jarkao2@gmail.com>
> > > Date: Wed, 14 Jan 2009 08:53:08 +0000
> > > 
> > > > Actually, I still think my second approach (the PageSlab) is probably
> > > > (if tested) the easiest for now, because it should fix the reported
> > > > (Willy's) problem, without any change or copy overhead for splice to
> > > > file (which could be still wrong, but not obviously wrong).
> > > 
> > > It's a simple fix, but as Herbert stated it leaves other ->sendpage()
> > > implementations exposed to data corruption when the from side of the
> > > pipe buffer is a socket.
> > 
> > I don't think Herbert meant other ->sendpage() implementations, but I
> > could miss something.
> 
> I think he did :-)

I hope Herbert will make it clear.

> 
> Or, more generally, he could have been referring to splice pipe
> outputs.  All of these things grab references to pages and
> expect that to keep the underlying data from being reallocated.
> 
> That doesn't work for this skb->data case.
> 
> > > That, to me, is almost worse than a bad fix.
> > > 
> > > It's definitely worse than a slower but full fix, which the copy
> > > patch is.
> > 
> > Sorry, I can't see how this patch could make sendpage worse.
> 
> Because that patch only fixes TCP's ->sendpage() implementation.

Yes, it fixes (I hope) the only reported implementation.

> 
> There are others out there which could end up experiencing similar
> data corruption.

Since this fix is very simple (and IMHO safe) it could be probably
used elsewhere too, but I doubt we should care at the moment.

Jarek P.
