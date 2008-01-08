Return-Path: <linux-kernel-owner+w=401wt.eu-S1753143AbYAHKKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbYAHKKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYAHKKg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:10:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38535 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbYAHKKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:10:35 -0500
Date: Tue, 8 Jan 2008 11:10:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 2.6.24-rc7, intel audio: alsa doesn't say a beep
Message-ID: <20080108101024.GB6906@elte.hu>
References: <4782833D.3010600@t-online.de> <s5h3at8rd9c.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h3at8rd9c.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> > The only difference between rc6 and rc7 in sound/pci/hda/hda_intel.c is
> > this:
> > 
> > diff -ur linux-2.6.24-rc6/sound/pci/hda/hda_intel.c linux-2.6.24-rc7/sound/pci/hda/hda_intel.c
> > --- linux-2.6.24-rc6/sound/pci/hda/hda_intel.c	2007-12-21 02:25:48.000000000 +0100
> > +++ linux-2.6.24-rc7/sound/pci/hda/hda_intel.c	2008-01-06 22:45:38.000000000 +0100
> > @@ -555,7 +555,8 @@
> >   		}
> >   		if (!chip->rirb.cmds)
> >   			return chip->rirb.res; /* the last value */
> > -		schedule_timeout_uninterruptible(1);
> > +		udelay(10);
> > +		cond_resched();
> >   	} while (time_after_eq(timeout, jiffies));
> > 
> >   	if (chip->msi) {
> > 
> > 
> > Do you think this could be related to the problem?
> 
> Could you revert it and check whether the problem still exists?
> 
> I hardly believe it's the culprit, but if this is the only change in
> the sound subsystem...

lets revert it (commit 57a04513cb3) if it's causing problems. This patch 
sat in -mm for quite some time - so it seems -rc7 is getting pretty good 
test coverage.

	Ingo
