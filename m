Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZD1MsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZD1MsW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 08:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757786AbZD1Mrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 08:47:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39033 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671AbZD1Mrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 08:47:51 -0400
Date: Tue, 28 Apr 2009 13:47:47 +0100
From: Mark Brown <broonie@sirena.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
       lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator core: fix double-free in
	regulator_register() error path
Message-ID: <20090428124746.GI14626@sirena.org.uk>
References: <alpine.DEB.2.00.0904250526210.28378@utopia.booyaka.com> <200904280232.56329.david-b@pacbell.net> <20090428110052.GH14626@sirena.org.uk> <200904280447.52954.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904280447.52954.david-b@pacbell.net>
X-Cookie: A company is known by the men it keeps.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 04:47:52AM -0700, David Brownell wrote:
> On Tuesday 28 April 2009, Mark Brown wrote:
> > On Tue, Apr 28, 2009 at 02:32:56AM -0700, David Brownell wrote:

> > > > > What it lacks is something entirely different: ?driver support
> > > > > for the LCD which uses the regulator framework,

> > > > It's not VAUX3 that it's saying has incomplete constraints, it's the
> > > > board as a whole - if the constraints for the board were fully specified

> > > No; driver support != constraint.  Only one of the
> > > issues is packaged as a "constraint".

> > Driver support isn't particularly relevant here.

> It's the *entire* point.  The driver is talking directly
> to the regulator, bypassing this framework.  The constraints
> on that regulator are fully defined ... and then bypassed.

Ah, I see - I didn't realise that there was driver support that doesn't
use the regulator API, that had been dropped out of context by that
point in the discussion.  I guess the LCD driver will be converted to
use the API in due course, hopefully there aren't too many other such
drivers.

This is the sort of use case that made me not want to have the API
disable unused regulators by default - there's stuff going on that the
regulator API and the code using it doesn't know about (since it's going
through some other interface to do the job in this case) so the API
can't safely do anything to that regulator.

> > > How about:  "VAUX3 board support is incomplete".
> > > That's accurate.

> > No.  The constraints being complete is a property of the board as a
> > whole and not the particular regulator.

> Except ... that "constraint" isn't the issue, it's
> unexpected driver behavior.  And "board" is exactly

This is sufficiently unexpected that it's the first time I've seen
anything bypassing the regulator API; in any case, it's just a question
of where you see the problem coming from.

My terminology comes from the fact that as far as the core is concerned
the issue is that the board didn't say it had given the core complete
constraints allowing it to fully control the regulators that are visible
to it.  The reason the board didn't do that is that is that the LCD
driver is bypassing the regulator API and the regulator API doesn't have
any way to express that possibility.

> what I said, so I don't know why you're arguing.
> (For the "fun" of it?)

David, that is really not necessary or constructive.  This sort of
disparaging remark has been a constant feature of your interactions on
regulator API issues and it is not achieving anything useful.

> Board support includes full driver support, as well
> as board setup (constraints).  That's the common way
> to factor it, at any rate -- a "board support package"
> addresses both, and they need to work together.

s/board/machine driver/; in an ideal world for Linux there is no BSP,
it's all mainline.
