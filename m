Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbYANQMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbYANQMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:12:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750845AbYANQMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:12:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbYANQML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:12:11 -0500
Date: Mon, 14 Jan 2008 17:11:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: [patch] auto-qa Kconfig
Message-ID: <20080114161150.GC15542@elte.hu>
References: <20071222233056.d652743e.akpm@linux-foundation.org> <20071231121115.b7ae39e4.randy.dunlap@oracle.com> <20080112010528.GA1590@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080112010528.GA1590@kroah.com>
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


* Greg KH <greg@kroah.com> wrote:

> > and that is after fixing (in some sense) the first CONFIG_BLOCK=n 
> > problem with the patch below.  Please test lots of configs. and/or 
> > use 'make randconfig' (automated, scripted, e.g., etc.). maybe check 
> > Documentation/SubmitChecklist.  :)
> 
> Ingo seems to be saying that he has some kind of "automated" build 
> system to do this kind of checking.  Ingo, did you ever post how you 
> did this anywhere?  I have enough spare machines here that I should be 
> able to set up something to test my stuff this way easier than doing 
> it by hand all the time (as the above problem proves I do miss things 
> :( )

the crux of it is this patch:

  http://redhat.com/~mingo/auto-qa-patches/Kconfig-qa.patch

(ontop of x86.git)

adjust your arch/x86/Kconfig.needed whitelist (should already work on 
typical systems) and do a 'make randconfig'. Every config is supposed to 
build and boot fine, including 'make allnoconfig' and 'make 
allyesconfig'. And please let me know about any blacklist items as well. 
(right now they are a bit hacky via a "depends on 0" line and a small 
comment explaining why they are not suitable in a bzImage kernel.)

( the CONFIG_BOOTPARAM stuff is there to easily randomize boot options - 
we frequently have regressions that only trigger with certain boot 
option combinations. )

it's somewhat hackish in places. The rest of my scripts (to scp a new 
kernel image, to reboot a testbox, etc.) tie in to my specific 
environment quite closely and make no sense to be posted. (they are also 
quite ugly)

	Ingo
