Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbZFRMNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbZFRMNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751084AbZFRMNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:13:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36379 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbZFRMNl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:13:41 -0400
Date: Thu, 18 Jun 2009 14:13:20 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] ntp updates for 2.6.31
Message-ID: <20090618121320.GA13025@localhost>
References: <alpine.LFD.2.00.0906151452000.2800@localhost.localdomain> <1f1b08da0906151316s7d25f8ceraa1bc967a8abe172@mail.gmail.com> <1f1b08da0906151641u4cd964e6vf1a61afe50cc1d90@mail.gmail.com> <20090616090647.GD13771@elte.hu> <20090616125248.GA23541@localhost> <1245253102.6067.94.camel@jstultz-laptop> <20090617172325.GA32332@localhost> <20090617172601.GA3493@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617172601.GA3493@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 07:26:01PM +0200, Ingo Molnar wrote:
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

Not really. It depends on how noisy is the input signal. On an idle
LAN the jitter is just few microseconds, but over internet it easily
reaches miliseconds. Over a certain point faster PLL will just make
things worse.

PLL is mainly about handling the signal noise, frequency adjusting is
secondary. When the noise is very low or the update interval is long
enough, the frequency variations caused by temperature changes will
dominate the signal noise and this is where FLL should kick in.

The PLL/FLL switching is controlled by update interval. Ideally it
would be adaptive, but NTP is not that sophisticated. By default, FLL
is enabled when the interval is longer than 2048 seconds. This is of
course not the optimal value for all systems.

Unfortunately in kernel it can be configured only to 2048 or 256 and
NTP never uses the shorter one. The NTP daemon has its own loop which
can be used instead and it allows to use arbitrary values though.

-- 
Miroslav Lichvar
