Return-Path: <linux-kernel-owner+w=401wt.eu-S1761198AbZEFUxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761198AbZEFUxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZEFUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:53:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39484 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZEFUxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:53:42 -0400
Date: Wed, 6 May 2009 22:51:45 +0200
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
Subject: Re: [patch] random: make get_random_int() more random
Message-ID: <20090506205145.GA1908@elte.hu>
References: <20090505055011.GE31071@waste.org> <20090505063156.GA24504@elte.hu> <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090506204156.GB31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506204156.GB31071@waste.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matt Mackall <mpm@selenic.com> wrote:

> On Wed, May 06, 2009 at 10:09:54PM +0200, Ingo Molnar wrote:
> > I then ran the FIPS randomness test over the first 20,000 bits [2.5K 
> > data], which it passed:
> 
> That's proves nothing except that you have no idea what you're 
> talking about. People regularly break things that FIPS gives 
> flying colors. FIPS is nothing but a statistical sanity-check.

The current code didnt even pass the FIPS test, due to:

           <...>-1739  [000]   112.487579: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487583: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487584: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487585: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487586: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487588: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487589: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487590: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487592: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487593: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487594: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487595: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487597: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487598: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487599: sys_prctl: get_random_int(): d1f8a190
           <...>-1739  [000]   112.487601: sys_prctl: get_random_int(): d1f8a190

Linus's patch is a marked improvement, and it is really what we need 
here mostly.

We cannot afford true physical randomness (it's too expensive to get 
and not all hw has it), and even a 'good' PRNG is pretty expensive. 
Performance is the main reason why the networking stack has its own 
fast hack.

> Do you need this to be publicly broken again by someone who 
> actually knows something about cryptanalysis before you'll accept 
> that it's a bad idea? If so, then please move the code out of 
> random.c, so that I don't have to share in your embarassment a 
> second time.

I see your flame, but what's your technical point?

	Ingo
