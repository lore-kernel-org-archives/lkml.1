Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYGOWMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYGOWMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753544AbYGOWMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:12:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46356 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753522AbYGOWMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:12:44 -0400
Date: Tue, 15 Jul 2008 15:11:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: davem@davemloft.net, mingo@elte.hu, nhorman@tuxdriver.com,
       simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
 000000000000000e (reset_prng_context)
Message-Id: <20080715151110.d7a17c89.akpm@linux-foundation.org>
In-Reply-To: <20080715214929.GA18268@martell.zuzino.mipt.ru>
References: <487BE071.80101@simon.arlott.org.uk>
	<20080715020428.GA27463@hmsendeavour.rdu.redhat.com>
	<20080715113304.GA30565@elte.hu>
	<20080715.134407.150543177.davem@davemloft.net>
	<20080715214929.GA18268@martell.zuzino.mipt.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jul 2008 01:49:30 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Tue, Jul 15, 2008 at 01:44:07PM -0700, David Miller wrote:
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > > i have just triggered this crash too. Please, when you know about bootup 
> > > crashes in your code send a patch to the lkml thread so that people can 
> > > apply it and have a working system.
> > > 
> > > Note that the new crypto/prng.c driver has very bad quality:
> > > 
> > >   total: 45 errors, 21 warnings, 1 checks, 410 lines checked
> > > 
> > > It has tons of completely unacceptable code mistakes in it.
> > 
> > I think we should merge new drivers as aggressively as possible.
> 
> Well, I don't have strong opinion about this exact statement, but
> 
> 	Ingo, COULD YOU PLEASE PERSONALLY FUCKING STOP THIS
> 	CHECKPATCH.PL-AS-INDICATOR HORSESHIT !

Well I wouldn't put it that way but sure, there is no clear correlation.

Except that such a high density of coding-style errors is an indication
that the code was not closely and critically reviewed by an experienced
kernel developer.

> Every damn single warning in this case is about whitespace or 80 column limit.
> 
> Every damn single one!
> 
> The hacker of your calibre should know the difference between whitespace-bad code
> and bug-ridden-bad code.
> 
> 
> What are those unacceptable mistakes?
> 
> Don't read the code again, what are those mistakes?
> 

Sleeping inside spinlock?

> 
> I _very_ briefly looked at prng.c and place I find wrong it passing
> "int nbytes" to get_prng_bytes(). It should be unsigned at least.
> 
> checkpatch.pl says about this? Suuuure, it does...

If we're going to merge code which has zillions of trivially-detectable
coding-style errors and which hasn't been runtime tested with very
mainstream kernel debug options enabled and which afacit hasn't been
reviewed then we have no standards at all.
