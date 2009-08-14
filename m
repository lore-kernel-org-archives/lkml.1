Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZHOQUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZHOQUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:20:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZHOQUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:20:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60808 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbZHOQUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:20:19 -0400
Date: Fri, 14 Aug 2009 18:32:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
	userspace-consumer)
Message-ID: <20090814163201.GB1626@ucw.cz>
References: <20090810200553.GB4652@gandalf> <20090810215800.GB4528@sirena.org.uk> <20090811054438.GA7176@gandalf> <20090811094020.GA6762@rakim.wolfsonmicro.main> <1249986616.5807.28.camel@odin> <20090811204914.GB13969@gandalf> <20090811223645.GA4691@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090811223645.GA4691@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > and wrt SBS, that would mean basically writing a driver for that Smart
> > Batery Charger and the Smart Battery devices creating means for some
> > entity to tell _start_charging_ based on the presence of a power source.
> 
> For me the critical thing is that we ensure that the charger won't be
> left charging at anything more than a trickle charge when there's
> nothing monitoring the battery status.  If the charger can do the SBS
> charger stuff autononmously it can look after itself (but the use of the
> regulator API becomes more questionable for those devices since the
> charger will be doing all the management of the regulators).  If the SBS
> is done entirely in software the kernel at least needs to be able to
> notice the management software exiting and clean up after it, even if
> that's all it is able to do for itself.

Please don't put basic fastcharge logic to userspace:

* you still want to fastcharge at init=/bin/bash boot

* you want to fastcharge while machine is in s2ram. See spitz. Doing
  that with userspace would be quite tricky.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
