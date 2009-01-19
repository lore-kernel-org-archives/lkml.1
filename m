Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbZASIlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbZASIlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 03:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZASIlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 03:41:00 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:44701 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbZASIk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 03:40:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F620qdqjCf/ypjAhwE9tQyVVj62M4N9hEc0hMJqGCJoxiQYg8hJRBbpwmtKp68a4iQ
         5zpTG/6xRLvVLqy3WO9udNjX23bqIpnXgNOlt7xajYDB6DTngdJR4LiiBqggPQpE1Y02
         BtFoIKFLsvrCmQq+lIpssd+sGO+HpKmVXeGi4=
Date: Mon, 19 Jan 2009 08:40:52 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: David Miller <davem@davemloft.net>, herbert@gondor.apana.org.au,
       zbr@ioremap.net, dada1@cosmosbay.com, ben@zeus.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090119084051.GB4788@ff.dom.local>
References: <20090115.155434.206643894.davem@davemloft.net> <20090119004206.GA10396@1wt.eu> <20090119030844.GA31941@gondor.apana.org.au> <20090118.192719.198405397.davem@davemloft.net> <20090119061420.GB12946@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090119061420.GB12946@1wt.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 07:14:20AM +0100, Willy Tarreau wrote:
> On Sun, Jan 18, 2009 at 07:27:19PM -0800, David Miller wrote:
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Date: Mon, 19 Jan 2009 14:08:44 +1100
> > 
> > > On Mon, Jan 19, 2009 at 01:42:06AM +0100, Willy Tarreau wrote:
> > > >
> > > > Just for the record, I've now re-integrated those changes in a test kernel
> > > > that I booted on my 10gig machines. I have updated my user-space code in
> > > > haproxy to run a new series of tests. Eventhough there is a memcpy(), the
> > > > results are EXCELLENT (on a C2D 2.66 GHz using Myricom's Myri10GE NICs) :
> > > > 
> > > >   - 4.8 Gbps at 100% CPU using MTU=1500 without LRO
> > > >     (3.2 Gbps at 100% CPU without splice)
> > > 
> > > One thing to note is that Myricom's driver probably uses page
> > > frags which means that you're not actually triggering the copy.
> 
> So does this mean that the corruption problem should still there for
> such a driver ? I'm asking before testing, because at these speeds,
> validity tests are not that easy ;-)

I guess, David meant the performance: there is not much change because
only a small part could be copied. The most harmed should be jumbo
frames in linear only skbs. But no corruption is expected.

Jarek P.
