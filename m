Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZJFQla@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZJFQla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756799AbZJFQl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:41:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46094 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756651AbZJFQl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:41:28 -0400
Date: Tue, 6 Oct 2009 18:40:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc3
Message-ID: <20091006164028.GA23305@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain> <alpine.LFD.2.00.0910052140100.309@localhost.localdomain> <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com> <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain> <20091006144449.GA23078@elte.hu> <alpine.LFD.2.01.0910060815320.3432@localhost.localdomain> <20091006153632.GA29795@elte.hu> <alpine.LFD.2.01.0910060843560.3432@localhost.localdomain> <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0910060925490.3432@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, 6 Oct 2009, Linus Torvalds wrote:
> > 
> > Unless:
> > 
> > > _That_ i think is a lot harder to confuse with the real .31 than a 
> > > v2.6.31-1234-g16123c4 version string.
> > 
> > .. are you saying that it would be just some automatically generated 
> > thing, just a crippled form of CONFIG_LOCALVERSION_AUTO? Kind of a 
> > CONFIG_LOCALVERSION_AUTO_SHORTFORM?
> 
> So how about this?
> 
> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial 
> way:
> 
>  - if it is set, things work the way they always have, and you get a 
>    extended kernel release like
> 
> 	2.6.32-rc3-00052-g0eca52a-dirty
> 
>  - but if it is _not_ set, we'll still try to get a version from the 
>    underlying SCM (we actually support git, hg and SVN right now, even if 
>    some comments may say "git only"), and if the underlying SCM says it 
>    has a local version, we append just "+", so you get a version number 
>    like
> 
> 	2.6.32-rc3+
> 
> IOW, you'd never get 2.6.32-rc0, but you'd get either the complex git 
> version number (or SVN/hg/whatever), or at least "2.6.31+" with the "+" 
> showing that it is more than plain 2.6.31.
> 
> The "+" could be anything else, of course. The diff is pretty obvious, 
> you can argue about exactly _what_ you'd like to see as a suffix for 
> "and then some".

Could we, for consistency's sake, make it:

 	2.6.32-rc3+00052-g0eca52a-dirty
 	2.6.32-rc3+

? Or do we want to keep the old version string alone for some reason?

The reason is that i have been confused in the past by having seen 
something like:

      2.6.29-00052-g0eca52a-dirty

and parsing out (in an admittedly weak moment) the gibberish after the 
first dash. Had it said:

      2.6.29+00052-g0eca52a-dirty

i'm sure i'd have noticed that it's not vanilla v2.6.29 - that plus sign 
stands out like a lightning rod.

	Ingo
