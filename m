Return-Path: <linux-kernel-owner+w=401wt.eu-S1757228AbYGPALn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbYGPALn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 20:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbYGPALf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 20:11:35 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2281 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753890AbYGPALe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 20:11:34 -0400
Date: Tue, 15 Jul 2008 20:04:43 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, davem@davemloft.net, mingo@elte.hu,
       simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       herbert@gondor.apana.org.au
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at
	000000000000000e (reset_prng_context)
Message-ID: <20080716000443.GA18297@hmsreliant.think-freely.org>
References: <487BE071.80101@simon.arlott.org.uk> <20080715020428.GA27463@hmsendeavour.rdu.redhat.com> <20080715113304.GA30565@elte.hu> <20080715.134407.150543177.davem@davemloft.net> <20080715214929.GA18268@martell.zuzino.mipt.ru> <20080715151110.d7a17c89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080715151110.d7a17c89.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> 
In fairness, I should have run checkpatch.pl on it before I submitted (sorry,
I'm bad about that), and I just missed the bad ifdef check for my startup test,
because I never thought to test with CRYPTO_PRNG built monolithically and no
support for the requisite cipher built in.  That was just stupid of of me, and I
apologize.

As its been pointed out though, these are trivial errors, and as such trivial to
fix (FWIW, the 45 errors from checkpatch boiled down to all spacing on about 10
different lines of code).   The PRNG works, is usefull, and for anything that
doesn't use it its irrelevant (now that it doesn't oops when built in).

At any rate, its all moot now anyway, I've posted patches that clean up the
whitespace, and fix the oops.  

Regards
Neil

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
