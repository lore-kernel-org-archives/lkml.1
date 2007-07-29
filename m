Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbXG2QES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbXG2QES (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763026AbXG2QEF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:04:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:19389 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762840AbXG2QEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:04:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HjwddQplM4vvUHnGX3qZ0/i4PHvDETksnqyeP4IPXB1ljwndd/kQsMnbwfwRtuSYwVm/3lhSDQ0maLwF0NEwPiKOolXdevrFqd7HH4IyI459AuZfs9JqFoSM1wOS63RpbjAZ/MDAh8Zc3qNn/EkyLIqS5qtOh3mfoZm1JvzBEyA=
Message-ID: <2c0942db0707290904n4356582dt91ab96b77db1e84e@mail.gmail.com>
Date: Sun, 29 Jul 2007 09:04:00 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans for 2.6.23]
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, david@lang.hm,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Mike Galbraith" <efault@gmx.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Frank Kingswood" <frank@kingswood-consulting.co.uk>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Jesper Juhl" <jesper.juhl@gmail.com>, "ck list" <ck@vds.kolivas.org>,
       "Paul Jackson" <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <46ACB40C.2040908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com>
	 <46AB166A.2000300@gmail.com>
	 <20070728122139.3c7f4290@the-village.bc.nu>
	 <46AC4B97.5050708@gmail.com>
	 <20070729141215.08973d54@the-village.bc.nu>
	 <46AC9F2C.8090601@gmail.com>
	 <2c0942db0707290758p39fef2e8o68d67bec5c7ba6ab@mail.gmail.com>
	 <46ACAB45.6080307@gmail.com>
	 <2c0942db0707290820r2e31f40flb51a43846169a752@mail.gmail.com>
	 <46ACB40C.2040908@gmail.com>
X-Google-Sender-Auth: a2c493077fa3b10b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/29/07, Rene Herman <rene.herman@gmail.com> wrote:
> On 07/29/2007 05:20 PM, Ray Lee wrote:
> This seems to be now fixing the different problem of swap-space filling up.
> I'm quite willing to for now assume I've got plenty free.

I was trying to point out that currently, as an example, memory that
is linear in a process' space could be fragmented on disk when swapped
out. That's today.

Under a log-structured scheme, one could set it up such that something
that was linear in RAM could be swapped out linearly on the drive,
minimizing seeks on writeout, which will naturally minimize seeks on
swap in of that same data.

> > So, at some point when the system needs to fault those blocks that
> > back in, it now has a linear span of sectors to read instead of asking
> > the drive to bounce over twenty tracks for a hundred blocks.
>
> Moreover though -- what I know about log structure is that generally it
> optimises for write (swapout) and might make read (swapin) worse due to
> fragmentation that wouldn't happen with a regular fs structure.

It looks like I'm not doing a very good job of explaining this, I'm afraid.

Suffice it to say that a log structured swap would give optimization
options that we don't have today.

> I guess that cleaner that Alan mentioned might be involved there -- I don't
> know how/what it would be doing.

Then you should google on `log structured filesystem (primer OR
introduction)` and read a few of the links that pop up. You might find
it interesting.

> I am very aware of the costs of seeks (on current magnetic media).

Then perhaps you can just take it on faith -- log structured layouts
are designed to help minimize seeks, read and write.

Ray
