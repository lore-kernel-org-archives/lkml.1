Return-Path: <linux-kernel-owner+w=401wt.eu-S1757507AbZEPOpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507AbZEPOpX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:45:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755693AbZEPOpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:45:07 -0400
Received: from waste.org ([66.93.16.53]:41931 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755664AbZEPOpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:45:05 -0400
Date: Sat, 16 May 2009 09:32:56 -0500
From: Matt Mackall <mpm@selenic.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>, Willy Tarreau <w@1wt.eu>,
       Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Dave Jones <davej@redhat.com>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090516143256.GC31071@waste.org>
References: <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar> <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain> <20090515134717.GA16389@elte.hu> <20090516100039.GA24619@1wt.eu> <20090516103909.GB6261@elte.hu> <m1bpptw90d.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpptw90d.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 05:02:42AM -0700, Eric W. Biederman wrote:
> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Willy Tarreau <w@1wt.eu> wrote:
> >
> >
> > Bad idea IMHO ...
> >
> > It is a bad idea because such sort of tunables do not really help 
> > the user as those who tweak are a distinct minority.
> >
> > Also, having a two-way hack _hinders_ your good idea from being 
> > adopted for example. Why bother with a faster hash and with using 
> > the resulting bits sparingly if we can get an 'easy' tunable in and 
> > can have two sub-par solutions instead of one (harder to implement) 
> > good solution?
> >
> > So tunables are really counter-productive - and this is a pet peeve 
> > of mine.
> >
> > Every time we have such a tunable for something fundamental we've 
> > not improved the kernel, we've documented a _failure_ in kernel 
> > design and implementation.
> >
> > Sure, we do use tunables for physical constants, limits and other 
> > natural parameters - and _sometimes_ we just grudingly admit defeat 
> > and admit that something is really impossible to implement. IMHO 
> > here we are not at that point yet, at all.
> 
> In the lwn comment section there was a suggestion to use a high
> quality stream cipher (AES?) instead of sha1 or the half md4 thing.
> Apparently those should be both stronger and faster.

Yes, this is something we've discussed. Unlike AES, the two hashes
we've been discussing are readily available in the kernel without
requiring cryptoapi.

It's also unclear that encrypting small blocks with software AES is
actually a performance win relative to SHA1, once you look at the key
scheduling overhead and the cache footprint of its s-boxes.

-- 
Mathematics is the supreme nostalgia of our time.
