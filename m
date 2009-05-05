Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbZEEQW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbZEEQW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 12:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZEEQWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 12:22:46 -0400
Received: from waste.org ([66.93.16.53]:34308 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692AbZEEQWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 12:22:45 -0400
Date: Tue, 5 May 2009 11:18:02 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Paris <eparis@redhat.com>, Jake Edge <jake@lwn.net>,
       linux-security-module@vger.kernel.org, mingo@redhat.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090505161802.GH31071@waste.org>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <alpine.LFD.2.01.0905041646240.4983@localhost.localdomain> <m1r5z40yyr.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905050755310.4983@localhost.localdomain> <alpine.LFD.2.01.0905050833180.4983@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0905050833180.4983@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 05, 2009 at 08:35:35AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 5 May 2009, Linus Torvalds wrote:
> > 
> > Note: the "pid + jiffies" is just meant to be a tiny tiny bit of noise. It 
> > has no real meaning. It could be anything. I just picked the previous 
> > seed, it's just that now we keep the state in between calls and that will 
> > feed into the next result, and that should make all the difference.
> 
> Actually, thinking about it, we could/should probably just remove that 
> tiny bit of noise.
> 
> After all, we get _real_ noise from the "keyptr->secret" thing. It's not 
> updated all the time, but it's certainly updated often enough that nobody 
> will ever see anything remotely guessable, I suspect.
> 
> Not that the "pid+jiffies" should hurt either, of course. It just doesn't 
> really look meaningful, and only exists as a historical oddity that 
> relates to the previous implementation of get_random_int().

I think it can only do good here. Recursively applied functions are
vulnerable to falling into greatly reduced state spaces (see 'strange
attractors') and adding any old crap can perturb it out of those
spaces. A good hash function should be resistant to this, but MD4 and
half_MD4 are not good hash functions.

-- 
Mathematics is the supreme nostalgia of our time.
