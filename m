Return-Path: <linux-kernel-owner+w=401wt.eu-S1751955AbYLWSqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbYLWSqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 13:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbYLWSqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 13:46:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951AbYLWSqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 13:46:21 -0500
Date: Tue, 23 Dec 2008 10:45:37 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: David Brownell <david-b@pacbell.net>
cc: Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net,
       lkml <linux-kernel@vger.kernel.org>,
       Vernon Sauder <vernoninhand@gmail.com>
Subject: Re: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
In-Reply-To: <200812211648.26699.david-b@pacbell.net>
Message-ID: <alpine.LFD.2.00.0812231040080.3535@localhost.localdomain>
References: <200812202332.36281.david-b@pacbell.net> <alpine.LFD.2.00.0812211545520.24883@localhost.localdomain> <200812211648.26699.david-b@pacbell.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 21 Dec 2008, David Brownell wrote:

> On Sunday 21 December 2008, Linus Torvalds wrote:
> > 
> > Hmm. In addition, isn't this broken (in that same function):
> 
> No -- this is full duplex.  The write_then_read() helper is
> simplifying a common half-duplex idiom for short operations,
> but the harware still does full duplex.  Buffer layout is:
> 
>   Before:	WWWWW0000000
>   After:	xxxxxRRRRRRR

Then, the problem is this:

        x.tx_buf = local_buf;
        x.rx_buf = local_buf;

which makes no sense. It's not two separate "tx_buf"/"rx_buf" things, it's 
just a single "buf".

Having two separate pointers is not only confusing, but it's actively 
WRONG, since the "rx_buf" clearly does not start at local_buf.

But that's not how most spi drivers seem to do it. They literally set 
tx_bug and rx_buf to different values. So again, none of what you talk 
about makes sense, and none of your "explanations" are anything but just 
incoherent noise.

So please explain how it can _possibly_ make sense to

 - have two separate pointers

 - and have one of them point to what is clearly not the data it is 
   supposed to point to.

Hmm?

			Linus
