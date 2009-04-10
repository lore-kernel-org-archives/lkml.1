Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbZDJKkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbZDJKkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 06:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756248AbZDJKk1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 06:40:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZDJKk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 06:40:26 -0400
Date: Fri, 10 Apr 2009 12:39:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, hpa@linux.intel.com, rjw@sisk.pl,
       linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [tip:x86/setup] x86, setup: "glove box" BIOS calls --
	infrastructure
Message-ID: <20090410103934.GA21506@elte.hu>
References: <49DE7F79.4030106@zytor.com> <tip-7a734e7dd93b9aea08ed51036a9a0e2c9dfd8dac@git.kernel.org> <20090410080444.GC16512@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410080444.GC16512@elf.ucw.cz>
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


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > x86, setup: "glove box" BIOS calls -- infrastructure
> > 
> > Impact: new interfaces (not yet used)
> > 
> > For all the platforms out there, there is an infinite number of buggy
> > BIOSes.  This adds infrastructure to treat BIOS interrupts more like
> > toxic waste and "glove box" them -- we switch out the register set,
> > perform the BIOS interrupt, and then restore the previous state.
> > 
> > LKML-Reference: <49DE7F79.4030106@zytor.com>
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> 
> Sounds quite sane. Disadvantage is that we will no longer detect 
> those buggy BIOSen.

I'd call that an advantage: sandboxing BIOS calls as much as we can 
and trusting all data from it as if it were a random packet from the 
Internet is the only sane way forward IMHO.

If we really care we could put in checks for unexpected register 
state changes ... but is it worth the trouble?

	Ingo
