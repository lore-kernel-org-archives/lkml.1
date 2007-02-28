Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008AbXB1VRH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbXB1VRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 16:17:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXB1VRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 16:17:06 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4077 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752008AbXB1VRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 16:17:05 -0500
Date: Wed, 28 Feb 2007 21:16:51 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, vatsa@in.ibm.com,
       Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228211651.GC4760@ucw.cz>
References: <200702272251.28844.rjw@sisk.pl> <200702282043.24779.rjw@sisk.pl> <20070228200853.GA122@tv-sign.ru> <200702282125.53318.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702282125.53318.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > OK, thanks.
> > 
> > We can (I think) do pretty much the same with some additional complications
> > in worker_thread() (check !cpu_online() after try_to_freeze() and break).
> 
> Okay, but I've just finished the patch that removes the freezability of
> workqueues (appended), so can we please do this in a separate one?

Hmm, nothing obviously wrong with the patch (ACK), but xfs people
should ack this one, too: 'is it okay to let xfs run while suspending'
is not a trivial question.

> Since freezable workqueues are broken in 2.6.21-rc
> (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> it's better to remove them altogether for 2.6.21 and change the only user of
> them (XFS) accordingly.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
