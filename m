Return-Path: <linux-kernel-owner+w=401wt.eu-S1757431AbZEPOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbZEPOBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852AbZEPOBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 10:01:04 -0400
Received: from 1wt.eu ([62.212.114.60]:1413 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953AbZEPOBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 10:01:03 -0400
Date: Sat, 16 May 2009 15:58:28 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, security@kernel.org,
       Linux@hera.kernel.org, stable@kernel.org,
       Cox <alan@lxorguk.ukuu.org.uk>, Arjan@hera.kernel.org,
       List <linux-kernel@vger.kernel.org>, Alan@hera.kernel.org,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Matt Mackall <mpm@selenic.com>, Dave Jones <davej@redhat.com>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, de Ven <arjan@infradead.org>
Subject: Re: [Security] [patch] random: make get_random_int() more random
Message-ID: <20090516135828.GA25283@1wt.eu>
References: <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090514164737.6eaab4f0@chukar> <alpine.LFD.2.01.0905141553010.3343@localhost.localdomain> <20090515134717.GA16389@elte.hu> <20090516100039.GA24619@1wt.eu> <20090516103909.GB6261@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090516103909.GB6261@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 16, 2009 at 12:39:09PM +0200, Ingo Molnar wrote:
> > And if we can't get a good hash to be fast enough, let's make this 
> > configurable. Most of us won't ever care about the strength of the 
> > hash. People concerned about security won't care about the slower 
> > hash. If we set the slower hash by default and have a tunable for 
> > it, everyone will have the solution that fits them.
> 
> Bad idea IMHO ...
> 
> It is a bad idea because such sort of tunables do not really help 
> the user as those who tweak are a distinct minority.
> 
> Also, having a two-way hack _hinders_ your good idea from being 
> adopted for example. Why bother with a faster hash and with using 
> the resulting bits sparingly if we can get an 'easy' tunable in and 
> can have two sub-par solutions instead of one (harder to implement) 
> good solution?
> 
> So tunables are really counter-productive - and this is a pet peeve 
> of mine.
> 
> Every time we have such a tunable for something fundamental we've 
> not improved the kernel, we've documented a _failure_ in kernel 
> design and implementation.

I don't agree with your point. It is good when the user must choose
between performance and security. For instance, if we had to choose
between a very slow but secure TCP stack and a very fast but less
secure one, instead of making it half way for everyone, I'd prefer
to be able to select my usage. You see this in Solaris with their
tcp_strong_iss tunable (which provides more values than needed, as
people only use either 0 (fast) or 2 (secure)).

As long as we're not forced to choose between the two possibilities,
we don't need a tunable, but if we are forced to slow down exec by
20%, surely there are people who would prefer to ignore the security
aspect and keep their original performance.

Willy

