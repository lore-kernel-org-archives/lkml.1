Return-Path: <linux-kernel-owner+w=401wt.eu-S937480AbYD1UbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937480AbYD1UbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 16:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbYD1UbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 16:31:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36376 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932381AbYD1UbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 16:31:05 -0400
Date: Mon, 28 Apr 2008 22:30:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] dvb: build failure fix
Message-ID: <20080428203056.GI15840@elte.hu>
References: <20080428162421.GA16566@elte.hu> <20080428164730.43349c3d@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428164730.43349c3d@gaivota>
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


* Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> On Mon, 28 Apr 2008 18:24:21 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > fix build failure found via x86.git randconfig testing:
> > 
> >  drivers/built-in.o: In function `tda829x_attach':
> >  : undefined reference to `tda827x_attach'
> >  drivers/built-in.o: In function `tda829x_attach':
> >  : undefined reference to `tda18271_attach'
> 
> >  config TUNER_XC2028
> >  config TUNER_MT20XX
> >  config TUNER_TEA5761
> >  config TUNER_TEA5767
> >  config TUNER_SIMPLE
> >  config TUNER_TDA9887
> 
> Hmm... if the issues are with tda827x and tda18271, why have you 
> touched on the above drivers? I can't see why the above tuners would 
> need DVB.

ah, ok. I just copy & pasted to everything that had "depends on I2C".

> >  config TUNER_TDA8290
> >  	tristate "TDA 8290/8295 + 8275(a)/18271 tuner combo"
> > -	depends on I2C
> > +	depends on I2C && ((DVB_CORE = m && m) || (DVB_CORE = y))
> >  	select DVB_TDA827X
> >  	select DVB_TDA18271
> >  	default m if VIDEO_TUNER_CUSTOMIZE
> 
> Ok, this one may be broken.
> 
> I'm working on some changes that will hopefully fix this issue at the 
> proper way.

ok, great. FYI, this has been reported months ago too so it's a 
long-time breakage - would be nice to fix it upstream even if it's the 
initial fix is a band-aid.

	Ingo
