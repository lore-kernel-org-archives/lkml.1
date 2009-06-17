Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZFQR4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZFQR4o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 13:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZFQR4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 13:56:36 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38812 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbZFQR4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 13:56:35 -0400
Subject: Re: [GIT pull] ntp updates for 2.6.31
From: John Stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Miroslav Lichvar <mlichvar@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090617172601.GA3493@elte.hu>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain>
	 <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com>
	 <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com>
	 <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost>
	 <1245253102.6067.94.camel@jstultz-laptop>
	 <20090617172325.GA32332@localhost>  <20090617172601.GA3493@elte.hu>
Content-Type: text/plain
Date: Wed, 17 Jun 2009 10:55:42 -0700
Message-Id: <1245261342.6067.102.camel@jstultz-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-17 at 19:26 +0200, Ingo Molnar wrote:
> * Miroslav Lichvar <mlichvar@redhat.com> wrote:
> 
> > Still, I'd really like to see the original behavior restored. Most 
> > of the users complaining about slow convergence are probably just 
> > hitting the calibration problem, which needs to be fixed by other 
> > means than making PLL faster. Also, users of other systems seem to 
> > be happy with their slow convergence. At least that's the 
> > impression I have from NTP lists.
> 
> Wouldnt the goal be to calibrate as fast as possible? (Without any 
> bad oscillation)

I believe he means the TSC calibration error issue, where every boot the
TSC calibration varies by 30-80ppm. This makes it hard for systems to
stay in NTP sync after a reboot, because ntpd has to search for a new
freq (and the SHIFT_PLL & time_constant values control how fast that
happens).

While the TSC calibration is an issue, there is also the fact that NTP's
slow convergence model (which is "by design", for good or bad) doesn't
seem to handle thermal environment changes quickly enough to keep close
sync.

Now, weather we fix the change by tweaking ntpd or the kernel, I still
think is a question that we've not answered well. Even though I'm of the
opinion something needs to change, I'm not yet convinced of which side
is the right side to fix. And that is why I requested we hold off on
merging the SHIFT_PLL patch.

And really, if you look at Miroslav's patch, which is mathematically
equivalent to the SHIFT_PLL change, all we're doing is decreasing what
ntpd gave as the time_constant us by two. So the question is, why is
that fix best done in the kernel, instead of making ntpd reduce what it
passes in to the kernel?

thanks
-john

