Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYHTKqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYHTKqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 06:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbYHTKqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 06:46:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42846 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYHTKqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 06:46:11 -0400
Date: Wed, 20 Aug 2008 12:45:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: Samuel Sieb <samuel@sieb.net>, linux-kernel@vger.kernel.org,
       "Rafael C. de Almeida" <almeidaraf@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Magnus Damm <magnus@valinux.co.jp>, takada <takada@mbf.nifty.com>
Subject: Re: kernel won't boot on a Cyrix MediaGXm (Geode )
Message-ID: <20080820104538.GF2816@elte.hu>
References: <48841A92.4020301@sieb.net> <489A82D5.6020903@sieb.net> <20080820093238.GA22511@elte.hu> <200808201144.02919.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808201144.02919.jbe@pengutronix.de>
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


* Juergen Beisert <jbe@pengutronix.de> wrote:

> On Mittwoch, 20. August 2008, Ingo Molnar wrote:
> > * Samuel Sieb <samuel@sieb.net> wrote:
> > > Ingo Molnar wrote:
> > >> any patch we should pick up to make your box boot?
> > >
> > > I've looked through various datasheets and found that the GXm and GXLV
> > > Geode processors don't have an incrementor.  I attached two patches. One
> > > only calls the incrementor setup for GX1 or better.  The other one
> > > removes the incrementor setup entirely.  As the incrementor value
> > > differs according to clock speed and we would hope that the BIOS
> > > configures it correctly, it is probably the better one to choose.  But I
> > > will leave that choice up to you.  Either one works for me. :-)
> >
> > i went for the commit below and queued it up in tip/x86/urgent - thanks
> > Samuel.
> >
> > what happens if the incrementor is not set up correctly by the BIOS
> 
> The system can freeze. The clock the incrementor modifies is used for 
> the external SDRAM (something like a delay line or jitter reduction). 
> Thats why its setting depends on the core clock speed.

so, what's the recommendation - is the patch fine? (which removes 
incrementor setting, leaving it to the BIOS)

	Ingo
