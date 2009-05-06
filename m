Return-Path: <linux-kernel-owner+w=401wt.eu-S1760915AbZEFV0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760915AbZEFV0s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759516AbZEFV0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:26:37 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48892 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759455AbZEFV0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:26:36 -0400
Date: Wed, 6 May 2009 23:24:05 +0200
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
Message-ID: <20090506212405.GB4861@elte.hu>
References: <m14ow0ynjm.fsf@fess.ebiederm.org> <20090505195246.GC21973@elte.hu> <20090505202219.GL31071@waste.org> <20090506103034.GA25203@elte.hu> <20090506162543.GT31071@waste.org> <alpine.LFD.2.01.0905060942340.4983@localhost.localdomain> <20090506200954.GA21484@elte.hu> <20090506204156.GB31071@waste.org> <20090506205145.GA1908@elte.hu> <20090506211020.GE31071@waste.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506211020.GE31071@waste.org>
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

> On Wed, May 06, 2009 at 10:51:45PM +0200, Ingo Molnar wrote:
> > Linus's patch is a marked improvement, and it is really what we need 
> > here mostly.
> 
> No one's arguing that it isn't an improvement. But -15 years of 
> research- points to MD4 (let alone **half**MD4) being 
> insufficient. To counter that, two non-cryptanalysts have 
> presented nothing beyond "it seems strong enough to me" and "it 
> passes a meaningless test". Pardon me if I'm not satisfied by 
> that.

So is it your point that mixing the cycle counter with a bad hash 
function is not sufficient? Not sufficient in precisely what threat 
model and against what attack vector? I'd like to hear specifics. 
The URLs pasted in this thread were inapposite - they were using 
information leaks from privileged contexts. If you have relevant 
URLs then please share them.

Are you worried about an attacker being able to run analysis code 
locally, trigger get_random_int() and observe its results, and then 
start a privileged context and know its address space layout?

I can tell you with near certainty that if we mix in the cycle 
counter (and those other task local and call local details) that 
then this attack vector is not practical on x86, at all.

( This particular attack would probably not be feasible even if we 
  used rot13 as the hash plus the cycle counter and the other values 
  - although i certainly feel more confident about this argument 
  with half-md4 in place as the hash. )

> > We cannot afford true physical randomness (it's too expensive to 
> > get and not all hw has it), and even a 'good' PRNG is pretty 
> > expensive.
> 
> And what of my suggestion (multiple times now) to replace halfMD4 
> with SHA1? Or AES. Or any cryptographic primitive that's not known 
> to be completely worthless?

They are all rather expensive, while the existing usage pattern for 
get_random_int() is really: "i want some randomness but also want it 
to be fast".

	Ingo
