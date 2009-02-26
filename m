Return-Path: <linux-kernel-owner+w=401wt.eu-S1759211AbZBZWcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759211AbZBZWcW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbZBZWcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:32:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752849AbZBZWcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:32:04 -0500
Date: Thu, 26 Feb 2009 14:31:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Thomas Gleixner <tglx@linutronix.de>
cc: john stultz <johnstul@us.ibm.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
Subject: Re: Linux 2.6.29-rc6
In-Reply-To: <alpine.LFD.2.00.0902261413400.3111@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902261426310.3111@localhost.localdomain>
References: <alpine.LFD.2.00.0902222023520.3111@localhost.localdomain>  <49A6F39F.9040801@krogh.cc>  <alpine.LFD.2.00.0902261232570.3111@localhost.localdomain>  <49A6FEE2.90700@krogh.cc>  <1f1b08da0902261319k7a60d80xaafc1101facfd2d9@mail.gmail.com> 
 <49A70B24.6090706@krogh.cc> <1235685269.6811.11.camel@localhost.localdomain> <alpine.LFD.2.00.0902262255190.9135@localhost.localdomain> <alpine.LFD.2.00.0902261413400.3111@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 26 Feb 2009, Linus Torvalds wrote:

> 
> 
> On Thu, 26 Feb 2009, Thomas Gleixner wrote:
> > 
> > Is the delta anything NTP might get upset about:
> > 
> > 2.6.26: time.c: Detected 2311.847 MHz processor.
> > 2.6.29: Detected 2310.029 MHz processor.
> > 
> > If yes, then we need to fix NTP not the calibration code :)
> 
> Well, that _is_ about 500ppm difference

Doing the math rather than just eyeballing it, I think it's closer to 
800ppm than 500ppm. But maybe I did that wrong too.

Which is definitely pretty far out. The theory is that if we can catch the 
edge of the PIT timer to 1us, and even if we get it maximally wrong at 
beginning/end (ie the difference is off by 2us), a 2us error over 15ms 
should be on the order of just a 133ppm error.

So 800ppm looks too big. We're clearly not getting to within 1us of the 
PIT timer event edge. But it would be interesting to hear whether making 
teh 15ms be 30ms will get us to a better place, and make ntp happier.

And maybe my math is just wrong, and it's not the "within 1us" assumption 
that was wrong.

		Linus
