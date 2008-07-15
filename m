Return-Path: <linux-kernel-owner+w=401wt.eu-S1763011AbYGOWjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763011AbYGOWjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYGOWj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:39:28 -0400
Received: from fk-out-0910.google.com ([209.85.128.187]:20443 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbYGOWj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:39:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jngP00/V8yntpN8BCRIxkvFUeZ35JzrpDy5US1DxVEbJxH28DXfnifQla5MTlGrfiU
         59HuSsLzlRxhBymk9zKnoGFLLytGcm9SAd02gld8vxR0ljdBDHidcpwjUYmsyFL3tEtU
         J1+KtZXUV7c/biCwTkzJjzG8PrFrkuJntNqRk=
Date: Wed, 16 Jul 2008 02:36:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: davem@davemloft.net, mingo@elte.hu, nhorman@tuxdriver.com,
       simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080715223644.GA13773@martell.zuzino.mipt.ru>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715151110.d7a17c89.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 03:11:10PM -0700, Andrew Morton wrote:
> On Wed, 16 Jul 2008 01:49:30 +0400
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > On Tue, Jul 15, 2008 at 01:44:07PM -0700, David Miller wrote:
> > > From: Ingo Molnar <mingo@elte.hu>
> > > 
> > > > i have just triggered this crash too. Please, when you know about bootup 
> > > > crashes in your code send a patch to the lkml thread so that people can 
> > > > apply it and have a working system.
> > > > 
> > > > Note that the new crypto/prng.c driver has very bad quality:
> > > > 
> > > >   total: 45 errors, 21 warnings, 1 checks, 410 lines checked
> > > > 
> > > > It has tons of completely unacceptable code mistakes in it.
> > > 
> > > I think we should merge new drivers as aggressively as possible.
> > 
> > Well, I don't have strong opinion about this exact statement, but
> > 
> > 	Ingo, COULD YOU PLEASE PERSONALLY FUCKING STOP THIS
> > 	CHECKPATCH.PL-AS-INDICATOR HORSESHIT !
> 
> Well I wouldn't put it that way but sure, there is no clear correlation.
> 
> Except that such a high density of coding-style errors is an indication
> that the code was not closely and critically reviewed by an experienced
> kernel developer.

So it's all about entrance? Looking at archives, I wouldn't say so.

> > Every damn single warning in this case is about whitespace or 80 column limit.
> > 
> > Every damn single one!
> > 
> > The hacker of your calibre should know the difference between whitespace-bad code
> > and bug-ridden-bad code.
> > 
> > 
> > What are those unacceptable mistakes?
> > 
> > Don't read the code again, what are those mistakes?
> > 
> 
> Sleeping inside spinlock?

Haven't found that place, but checkpatch.pl neither.

> > I _very_ briefly looked at prng.c and place I find wrong it passing
> > "int nbytes" to get_prng_bytes(). It should be unsigned at least.
> > 
> > checkpatch.pl says about this? Suuuure, it does...
> 
> If we're going to merge code which has zillions of trivially-detectable
> coding-style errors and which hasn't been runtime tested with very
> mainstream kernel debug options enabled and which afacit hasn't been
> reviewed then we have no standards at all.

No excuse for no runtime testing. No arguments about it.

But stamping code bad because it writes all loops as "for (i=0;i<N;i++)"
is unexplainble when person making such statements can rewrite OS
scheduler every weekend.

