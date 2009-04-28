Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbZD1Ktv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbZD1Ktv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 06:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755059AbZD1Ktl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 06:49:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41181 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002AbZD1Ktk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 06:49:40 -0400
Date: Tue, 28 Apr 2009 11:49:38 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.30-rc3] regulator: regression fix
Message-ID: <20090428104938.GG14626@sirena.org.uk>
References: <200904271959.40526.david-b@pacbell.net> <20090428083856.GD14626@sirena.org.uk> <200904280243.42927.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904280243.42927.david-b@pacbell.net>
X-Cookie: A company is known by the men it keeps.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 02:43:42AM -0700, David Brownell wrote:
> On Tuesday 28 April 2009, Mark Brown wrote:

> > The change you're making isn't relevant to what I suspect the actual
> > problem is (you didn't specify, I may be wrong here).

> Restoring the "else" fixed the logic flaw ...

I'm not sure the code ever worked for whatever it is you're doing with
it - it'd never have set a maximum voltage constraint.

> > The code that was being fixed was only even in -next for a relatively
> > brief period of time.

> This is the first time I've seen the "fix" though.  Recall that
> the code in question has been in use for several months now, while
> waiting to wend its way into mainline.  It might be useful to CC
> a few more folk on such "fix" patches.

The fix was nothing to do with the behaviour of fixed voltage regulators
- it was about restoring support for regulators without voltage
constraints.  The code looked like it was just one of the small
optimisations you're fond of, skipping the validity check since we just
set constraints which ought to be valid.

I should've pushed back harder on the obscure code in the first place.
