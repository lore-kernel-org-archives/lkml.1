Return-Path: <linux-kernel-owner+w=401wt.eu-S1757623AbZEPO2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757623AbZEPO2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754008AbZEPO2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:28:23 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:56423 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832AbZEPO2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:28:22 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Date: Sat, 16 May 2009 09:28:16 -0500
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
References: <20090505195246.GC21973@elte.hu> <m1bpptw90d.fsf@fess.ebiederm.org> <200905160900.04380.lkml@morethan.org>
In-Reply-To: <200905160900.04380.lkml@morethan.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905160928.19876.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat May 16 2009, Michael S. Zick wrote:
> On Sat May 16 2009, Eric W. Biederman wrote:
> > Ingo Molnar <mingo@elte.hu> writes:
> > 
> > > * Willy Tarreau <w@1wt.eu> wrote:
> > >
> > >
> > > Bad idea IMHO ...
> > >
> > > It is a bad idea because such sort of tunables do not really help 
> > > the user as those who tweak are a distinct minority.
> > >
> > > Also, having a two-way hack _hinders_ your good idea from being 
> > > adopted for example. Why bother with a faster hash and with using 
> > > the resulting bits sparingly if we can get an 'easy' tunable in and 
> > > can have two sub-par solutions instead of one (harder to implement) 
> > > good solution?
> > >
> > > So tunables are really counter-productive - and this is a pet peeve 
> > > of mine.
> > >
> > > Every time we have such a tunable for something fundamental we've 
> > > not improved the kernel, we've documented a _failure_ in kernel 
> > > design and implementation.
> > >
> > > Sure, we do use tunables for physical constants, limits and other 
> > > natural parameters - and _sometimes_ we just grudingly admit defeat 
> > > and admit that something is really impossible to implement. IMHO 
> > > here we are not at that point yet, at all.
> > 
> > In the lwn comment section there was a suggestion to use a high
> > quality stream cipher (AES?) instead of sha1 or the half md4 thing.
> > Apparently those should be both stronger and faster.
> > 
> > I don't know enough about it except to say that sounds right in
> > principle.
> > 
> > Apparently some of the BSDs do something similar with arc4random.
> > arc4 is old and in some case broken so it is unlikely to make a good
> > choice at this point, but the overall design of a stream cipher
> > that is rekeyed ever 5 minutes seems sound.
> > 
> > Eric
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> > 
> > 
> 
> And when building for the VIA processors that have the
> hardware rng in the padlock firmware - -
> Let the kernel use that for a high quality RNG.
> 
> Note: This may require a Kbuild tweak to force the via-rng
> driver to be built-in if this solution is selected.
> 
> PS: I have two (different) VIA C7-M machines available for testing.
>

Still getting kernel messages that there isn't a test for the rng - -
One (of many) ways to test the quality is to submit a bit string sample
to the Berlekamp-Massey algorithm; perhaps from repeated calls to the
generation function (it depends on your desired confidence level).

http://en.wikipedia.org/wiki/Berlekamp-Massey_algorithm 

If the solution is greater than a xyz bits long LFSR, the randomness 
is considered "good enough".

Note: The padlock firmware also has a Montgomery multiplier not yet 
exposed by a driver.

Mike
> Mike
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 


