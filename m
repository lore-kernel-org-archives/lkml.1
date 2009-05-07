Return-Path: <linux-kernel-owner+w=401wt.eu-S1759834AbZEGAye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759834AbZEGAye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbZEGAyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:54:23 -0400
Received: from waste.org ([66.93.16.53]:53477 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbZEGAyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:54:23 -0400
Date: Wed, 6 May 2009 19:50:16 -0500
From: Matt Mackall <mpm@selenic.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to non-privileged processes
Message-ID: <20090507005016.GJ31071@waste.org>
References: <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506175717.GY31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506175717.GY31071@waste.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 12:57:17PM -0500, Matt Mackall wrote:
> On Wed, May 06, 2009 at 09:48:20AM -0700, Linus Torvalds wrote:
> > 
> > Matt, are you willing to ack my suggested patch which adds history to the 
> > mix? Did somebody test that? I have this memory of there being an 
> > "exploit" program to show the non-randomness of the values, but I can't 
> > recall details, and would really want to get a second opinion from 
> > somebody who cares about PRNG's.
> 
> I still don't like it. I bounced it off some folks on the adversarial
> side of things and they didn't think it looked strong enough either.
> Full MD5 collisions can be generated about as fast as they can be
> checked, which makes _reduced strength_ MD4 not much better than an
> LFSR in terms of attack potential. So I suggest we either:
> 
> a) take my original patch 
> b) respin your patch using at least SHA1 rather than halfMD4 and
> changing the name to get_random_u32
> 
> If you'd prefer (b), I'll do the legwork.

I've done some basic benchmarks on the primitives here in userspace:

halfMD4 get_random_int: about .326us per call or 12.2MB/s
sha1 get_random_int: about .660us per call or 6.1MB/s
dd /dev/urandom: 3.6MB/s

So I think the SHA1 solution is quite competitive on the performance
front with far fewer concerns about its strength. I'll spin a proper
patch tomorrow.

-- 
Mathematics is the supreme nostalgia of our time.
