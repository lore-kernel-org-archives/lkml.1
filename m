Return-Path: <linux-kernel-owner+w=401wt.eu-S1759964AbZBETNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759964AbZBETNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 14:13:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbZBETNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 14:13:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40577 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbZBETNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 14:13:12 -0500
Date: Thu, 5 Feb 2009 20:12:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Norbert Preining <preining@logic.at>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, samr <sam@ravnborg.org>
Subject: Re: 2.6.29-rc3-git6: Reported regressions from 2.6.28
Message-ID: <20090205191234.GG20470@elte.hu>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <alpine.LFD.2.00.0902040759420.3247@localhost.localdomain> <20090204181109.GR21085@gamma.logic.tuwien.ac.at> <alpine.LFD.2.00.0902041012440.3247@localhost.localdomain> <20090204185606.GA12991@elte.hu> <1233809147.13118.8.camel@gaiman> <498B1F2A.70209@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498B1F2A.70209@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> Eric Anholt wrote:
> > On Wed, 2009-02-04 at 19:56 +0100, Ingo Molnar wrote:
> >> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >>
> >>> On Wed, 4 Feb 2009, Norbert Preining wrote:
> >>>> The problem is that if you have a configuration under 2.6.28 without 
> >>>> CONFIG_FB and just call make oldconfig, or even make config and don't 
> >>>> know that you loose the DRM. And I was using make oldconfig (there is a 
> >>>> graphical config?? ;-))
> >>> Sure. It's inconvenient, no question about that. I asked the i915 people 
> >>> to look into not requiring CONFIG_FB, and I hope they will, but my point 
> >>> is that I don't think we can consider "small one-time inconvenience" to be 
> >>> a "regression".
> >> if you mean that as a general principle, there's four very real downsides in 
> >> my opinion.
> >>
> >> Firstly, we could have done better (and still can do better), via various 
> >> easy and non-intrusive measures:
> >>
> >>    - We could add a runtime warning:
> >>
> >>       for example a WARN_ONCE("please enable CONFIG_DRM_I915 and CONFIG_FB") 
> >>       that there's no DRM because CONFIG_FB is not selected and oldconfig 
> >>       loses the I915 setting silently - placed in a key DRM ioctl, would 
> >>       have gone a long way addressing the issue. Testers do notice kernel 
> >>       warnings that pop up when their X gets slow. (This approach might also 
> >>       have the added bonus of warning folks who enable the wrong driver for 
> >>       the hardware.)
> >>
> >>    - Or we could add a more thoughtful Kconfig migration:
> >>
> >>       Rename DRM_I915 to DRM_I915_FB [which it really is now], and keep
> >>       DRM_I915 as a non-interactive migration helper: if set, it 
> >>       auto-selects both FB and DRM_I915_FB.
> >>
> >>       While CONFIG_FB is an interactive Kconfig option so a select can be 
> >>       dangerous to a correct dependency tree, it seems safe to do in this 
> >>       specific case because it seems to be a rather leaf entry with no 
> >>       dependencies.
> > 
> > I tried select FB.  It's the right thing to do.  It doesn't work.  I
> > posted to the mailing list two weeks ago about the insane dependency
> > chain that kbuild comes up with and fails on when we do this, and got
> > silence.
> 
> I tried what you had described in that email (from 2 weeks ago), got the
> same results that you did, but kbuild does seem very confused (to me).
> 
> reference email from 2+ weeks ago:
>   http://marc.info/?l=linux-kernel&m=123197341316461&w=2
> 
> Adding Sam to cc.

Check the patch i posted in this thread earlier today, it solves this 
problem.

	Ingo
