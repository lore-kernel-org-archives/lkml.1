Return-Path: <linux-kernel-owner+w=401wt.eu-S965424AbXBRA3Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965424AbXBRA3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 19:29:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965454AbXBRA3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 19:29:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34805 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965424AbXBRA3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 19:29:24 -0500
Date: Sun, 18 Feb 2007 01:29:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>, Greg KH <greg@kroah.com>
Cc: Alex Dubov <oakad@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [mmc] incorrect behavior on resume
Message-ID: <20070218002903.GF14773@elf.ucw.cz>
References: <77095.44448.qm@web36703.mail.mud.yahoo.com> <45D79145.7000604@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D79145.7000604@drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-02-18 00:35:33, Pierre Ossman wrote:
> Alex Dubov wrote:
> > And today: yet another problem with mmc.
> > It so happens that after resume mmc layer issues requests to the device before mmc_resume_host is
> > called at all. Moreover, this prevents the machine from resuming, unless worked around, because
> > software timer does not work at this stage of the resume and interrupts may not be delivered (if
> > card was removed, for example).
> 
> Now this sounds incredibly broken. A child device should never be resumed before
> its parent. Pavel, can you comment?

No, child devices should not be resumed before their parents. Is it
true child?

What bus is mmc on? Timer should be resumed fairly early...?

Can you confirm that rmmod/insmod of mmc around suspend fixes the issue?

But this is greg's area.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
