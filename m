Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbXJXVaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbXJXVaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 17:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759912AbXJXV3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 17:29:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:45574 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759744AbXJXV3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 17:29:53 -0400
Date: Wed, 24 Oct 2007 23:29:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, perex@suse.cz, tiwai@suse.de,
       torvalds@linux-foundation.org
Subject: Re: [patch] portman2x4.c: fix boot hang
Message-ID: <20071024212933.GA26110@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <20071024194417.GA17025@elte.hu> <E1Ikmae-0000at-OB@faramir.fjphome.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ikmae-0000at-OB@faramir.fjphome.nl>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Frans Pop <elendil@planet.nl> wrote:

> Ingo Molnar wrote:
> >  if ((parport_read_status(p) & ESTB) == ESTB)
> > -		return 1;	/* CODE 1 - Strobe Failure. */
> > +		return -EIO;	/* CODE 1 - Strobe Failure. */
> >  
> >  /* Set for RXDATA0 where no damage will be done. */
> >  /* 5 */
> > @@ -475,7 +475,7 @@ static int portman_probe(struct parport
> >  
> >  /* 6 */
> >  if ((parport_read_status(p) & ESTB) != ESTB)
> > -		return 1;	/* CODE 1 - Strobe Failure. */
> > +		return -EIO;	/* CODE 1 - Strobe Failure. */
> 
> Why are you keeping the "CODE 1" comment? Just "Strobe Failure" as 
> comment would seem more consistent with the change.

looking at other uses of 'CODE' suggested that 'CODE 1' is not the 
return code - so i left it alone.

	Ingo
