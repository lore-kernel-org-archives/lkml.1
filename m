Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbZEEGf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbZEEGf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbZEEGfP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:35:15 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53588 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZEEGfN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:35:13 -0400
Date: Tue, 5 May 2009 08:31:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matt Mackall <mpm@selenic.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Arjan van de Ven <arjan@infradead.org>, Jake Edge <jake@lwn.net>,
       security@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Roland McGrath <roland@redhat.com>, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Dave Jones <davej@redhat.com>
Subject: Re: [Security] [PATCH] proc: avoid information leaks to
	non-privileged processes
Message-ID: <20090505063156.GA24504@elte.hu>
References: <20090504125114.5e391564@chukar> <alpine.LFD.2.01.0905041159480.4983@localhost.localdomain> <20090504125124.0f469970@infradead.org> <m1vdogbows.fsf@fess.ebiederm.org> <alpine.LFD.2.01.0905041514350.4983@localhost.localdomain> <20090505055011.GE31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090505055011.GE31071@waste.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> As to what's the appropriate sort of RNG for ASLR to use, finding 
> a balance between too strong and too weak is tricky. [...]

In exec-shield i mixed 'easily accessible and fast' semi-random 
state to the get_random_int() result: xor-ed the cycle counter, the 
pid and a kernel address to it. That strengthened the result in a 
pretty practical way (without strengthening the theoretical 
randomless - each of those items are considered guessable) and does 
so without weakening the entropy of the random pool.

As usual, it got objected to and removed during upstream review so 
the upstream code stands on a single foot only - which is an 
obviously bad idea.

The thing is, it's very hard to argue for (and prove) security 
related complexity on an objective basis. ASLR was met with quite 
some upstream hostility, so it did not really get merged upstream, 
it barely managed to limp upstream.

	Ingo
