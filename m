Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbYJTL6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbYJTL6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbYJTL6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:58:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52325 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617AbYJTL6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:58:36 -0400
Date: Mon, 20 Oct 2008 13:58:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Keith Packard <keithp@keithp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sf.net, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: io resources and cached mappings (was: [git pull] drm patches
	for 2.6.27-rc1)
Message-ID: <20081020115810.GC10594@elte.hu>
References: <200810181237.49784.nickpiggin@yahoo.com.au> <1224357062.4384.72.camel@koto.keithp.com> <alpine.LFD.2.00.0810181220510.3438@nehalem.linux-foundation.org> <20081018203741.GA23396@elte.hu> <1224366690.4384.89.camel@koto.keithp.com> <20081018223214.GA5093@elte.hu> <1224389697.4384.118.camel@koto.keithp.com> <1224398496.5303.7.camel@koto.keithp.com> <20081019175320.GA6442@elte.hu> <1224450291.5303.23.camel@koto.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224450291.5303.23.camel@koto.keithp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Keith Packard <keithp@keithp.com> wrote:

> On Sun, 2008-10-19 at 19:53 +0200, Ingo Molnar wrote:
> 
> > Note how simple and consistent it all gets: IO resources already 
> > know their physical location and their size limits. Being able to 
> > cache an ioremap in a mapping [and being able to use atomic kmaps on 
> > 32-bit] is a relatively simple and natural extension to the concept.
> 
> I'm not sure I see any value in caching mappings here; we're mostly 
> interested in copying lots of data onto the card and so we use a lot 
> of different mappings; atomic mappings are easy to use, and efficient 
> enough.

yes but note that by caching the whole mapping on 64-bit we get 
everything we want: trivially lockless, works from any CPU, can be 
preempted at will, and there are no ugly INVLPG flushes anywhere.

you'll even get 2MB mappings automatically, if the BAR is aligned and 
sized correctly.

32-bit we should handle as well but not design for it.

	Ingo
