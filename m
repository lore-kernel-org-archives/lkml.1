Return-Path: <linux-kernel-owner+w=401wt.eu-S1753156AbYBJQny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156AbYBJQny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 11:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbYBJQnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 11:43:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbYBJQnp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 11:43:45 -0500
Date: Sun, 10 Feb 2008 17:43:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [3/6] kgdb: core
Message-ID: <20080210164327.GA7088@elte.hu>
References: <20080210071331.GC3851@elte.hu> <20080210124629.GA12200@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080210124629.GA12200@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Marcin Slusarz <marcin.slusarz@gmail.com> wrote:

> > +		if (CACHE_FLUSH_IS_SAFE) {
> > +			if (current->mm && addr < TASK_SIZE) {
> > +				flush_cache_range(current->mm->mmap_cache,
> > +						addr, addr + BREAK_INSTR_SIZE);
> > +			} else {
> > +				flush_icache_range(addr, addr +
> > +						BREAK_INSTR_SIZE);
> > +			}
> > +		}
> unneeded braces (here and in many other places)

this is a small detail, but you are wrong. These braces around 
multi-line statements are unneded _for the compiler_, but are very much 
wanted by humans. You'll see akpm, me and others reject/fix patches on a 
routine basis that make this cleanliness mistake. Please watch out for 
this when writing patches ;-)

> if ()
> else if ()
> else
> 
> will look better

nope. I consciously avoid that construct because it's dangerous: it can 
quite easily result in the wrong logic. Having _more_ braces than needed 
by the compiler is a style error in only a single, special case.

> > +	if (*(ptr++) != ',') {
> > +		error_packet(remcom_out_buffer, -EINVAL);
> > +		return;
> > +	} else {
> no else needed

agreed - fixed.

> if (!kgdb_hex2long()) {
> 	error_packet();
> 	return;
> }

fixed.

	Ingo
