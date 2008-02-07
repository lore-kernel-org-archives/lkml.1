Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbYBGKdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbYBGKdq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:33:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755206AbYBGKdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:33:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755038AbYBGKdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:33:37 -0500
Date: Thu, 7 Feb 2008 11:32:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Hugh Dickins <hugh@veritas.com>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ASLR: add possibility for more fine-grained
	tweaking
Message-ID: <20080207103231.GD16735@elte.hu>
References: <Pine.LNX.4.64.0802061438150.30955@jikos.suse.cz> <Pine.LNX.4.64.0802061442300.30955@jikos.suse.cz> <20080206134959.GA25689@elte.hu> <Pine.LNX.4.64.0802071120110.11914@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802071120110.11914@vixen.sonytel.be>
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


* Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> On Wed, 6 Feb 2008, Ingo Molnar wrote:
> > @@ -541,6 +541,18 @@ config ELF_CORE
> >  	help
> >  	  Enable support for generating core dumps. Disabling saves about 4k.
> >  
> > +config COMPAT_BRK
> > +	bool "Disable heap randomization"
> > +	default y
> > +	help
> > +	  Randomizing heap placement makes heap exploits harder, but it
> > +	  also breaks ancient binaries (including anything libc5 based).
> > +	  This option changes the bootup default to heap randomization
> > +	  disabled, and can be overriden runtime by setting
> > +	  /proc/sys/kernel/randomize_va_space to 2.
> > +
> > +	  On non-ancient distros (post-2000 ones) Y is usually a safe choice.
> 
> Somehow my belly feeling tells me something is wrong with this description...
> 
> Ah, a negative option (Y -> disable).  So Y is always safe.
> 
> `non-ancient distros' really means `recent distros', and if you have 
> one, then _N_ should be a safe choice, too?

yeah, you are right :-) I'll fix this.

btw., "non-ancient distros" does not just mean "recent distros", it 
really means "just about any distro you picked up in the past 10 years". 
You'd have to go out on a limb to find something historic (or keep 
copying /lib/libc5 binaries to new distros like Pavel did) to still have 
this particular libc5 assumption/breakage. [ Or at least so i hope =B-)]

	Ingo
