Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYJ1PRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYJ1PRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 11:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYJ1PRD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 11:17:03 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:57191 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751050AbYJ1PRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 11:17:01 -0400
Date: Tue, 28 Oct 2008 18:16:59 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Trent Piepho <tpiepho@freescale.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Richard Purdie <rpurdie@rpsys.net>,
       Sean MacLennan <smaclennan@pikatech.com>,
       Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 1/4] of_gpio: Return GPIO flags from of_get_gpio()
Message-ID: <20081028151659.GA26444@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <Pine.LNX.4.64.0810241442240.3790@t2.domain.actdsltmp> <1224889741-4167-1-git-send-email-tpiepho@freescale.com> <20081028143933.GA18453@oksana.dev.rtsoft.ru> <fa686aa40810280753lc555683y5d32da678384438@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <fa686aa40810280753lc555683y5d32da678384438@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2008 at 08:53:11AM -0600, Grant Likely wrote:
> On Tue, Oct 28, 2008 at 8:39 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > Can you repost a fixed version with my Ack and Cc: Andrew Morton,
> > Benjamin Herrenschmidt?
> >
> > I think this change should go into the 2.6.28, so that we can
> > write new code on top of new API. Otherwise this change will cause
> > issues in the next merge window.
> 
> While I like this series, it should not be pushed for .28.  The window
> is closed and we are in bug-fix-only mode.

IIRC, we approve API changes in the early -rcs, exactly to avoid build
break issues for the new code (though the API changes themselves are
discouraged).

> Focus on getting it into Ben's -next tree instead.

Would Benjamin apply the USB FHCI driver then? I doubt it.

So, there are options:

1. Either this patch go in into the .28;

2. Or this patch go in _after_ USB FHCI driver, and Trent takes care
   to convert it to the new API. (I'm trying to push the driver since
   2007, I think. Firstly it has GPIO framework dependency, QE GPIO,
   QE Pinmux, FSL GTM dependency, bindings, e.t.c. And now that.
   No, no deal. I quite tired of the dependencies for this driver.)

3. Or we apply my original patch that won't break the API.
   http://lkml.org/lkml/2008/7/25/236
   I still like it better than Trent's patch, exactly because it
   can't break anything.

> That will deal with any merge window
> conflicts.

This won't deal with build breakage because of API changes, which
means I can't submit FHCI driver to Greg, I have to wait for the
API changes applied.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
