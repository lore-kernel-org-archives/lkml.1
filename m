Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbZFKX2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbZFKX2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 19:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758212AbZFKX2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 19:28:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45536 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbZFKX2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 19:28:14 -0400
Date: Fri, 12 Jun 2009 01:28:07 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] pm: Move nvs routines into a seperate file.
Message-ID: <20090611232807.GA19752@elf.ucw.cz>
References: <20090604161847.513682672@de.ibm.com> <200906112346.28782.rjw@sisk.pl> <20090611220517.GF27376@elf.ucw.cz> <200906120030.00425.rjw@sisk.pl> <20090611232224.GB18682@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611232224.GB18682@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > > To fix this add some empty inline functions for !GENERIC_HARDIRQS.
> > > > > 
> > > > > I don't think that's right fix. If architecture does not use
> > > > > GENERIC_HARDIRQS, it may want to implement *_device_irqs()
> > > > > itself. Before your patch, it could, after your patch, it can not.
> > > > > 
> > > > > Better put those empty functions in arch/s390/include?
> > > > 
> > > > If any of the affected architectures wants to implement *_device_irqs()
> > > > itself, it can do the appropriate change in future.  For now, let's not break
> > > > compilation on them, shall we?
> > > 
> > > Well, if one of those architectures will want to implement
> > > *_device_irqs(), it will have to either modify s390, and all other
> > > !GENERIC_HARDIRQS architectures.
> > 
> > Why will it?  I think it will be sufficient to modify the header changed by
> > this patch and the architecture in question.
> 
> Hmm, how? Putting #ifndef MY_ARCH into generic header? Inventing
> CONFIG_NON_GENERIC_HARDIRQS_BUT_I_NEED_DEVICE_IRQS?

Maybe playing with attribute((weak)) is the cleanest solution?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
