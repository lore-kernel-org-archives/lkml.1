Return-Path: <linux-kernel-owner+w=401wt.eu-S1761877AbYD0RMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761877AbYD0RMT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 13:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbYD0RMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 13:12:10 -0400
Received: from www.tglx.de ([62.245.132.106]:33388 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754606AbYD0RMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 13:12:09 -0400
Date: Sun, 27 Apr 2008 19:12:01 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] UIO: generic platform driver
Message-ID: <20080427171201.GA3181@local>
References: <20080422094708.GB27126@digi.com> <1208857977-29493-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1208857977-29493-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <20080423085629.GA16776@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080423085629.GA16776@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2008 at 10:56:29AM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> Uwe Kleine-König wrote:
> > Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> > ---
> > Hello,
> > 
> > This is the former patch 4/4 after some discussion.
> > 
> > Open issues:
> >   - clock name "uio" isn't considered good by Russell King
> >     I don't have a better suggestion
> I added another branch[1] on my repo that doesn't have the dummy clk
> patch and variant of this one that doesn't use the clk API.
> 
> This way the clk API isn't needed anymore for my patch and the issue
> about the clock name disappeard, too.

Hi Uwe,
sorry for the delay, I was away for a few days and had an awful lot of
work when I came back.

About your generic platform driver: I think we've got two choices, both
of them are acceptable as far as I'm concerned:

1.) Use the clk API and make your driver depend on it. AFAICS, only ARM
and PPC implement it right now. On some platforms, it will probably
never be implemented. E.g. x86 doesn't have any clocks that could be
controlled that way. It's probably only useful for SoCs.
Advantages: People who need it get clk support for free, without having
to write much code.
Disadvantages: The generic platform driver is not available for all
platforms. It might not be easy to implement the dependency in Kconfig
in a way acceptable to all maintainers ;-)

2.) Don't use the clk API. I don't think we would lose much. Drivers
could implement clk stuff in their board support. You could add some
generic function pointers in struct uio_platdata that are called in
open/release/probe/remove. That way, any platform specific stuff,
including clk, could be handled.
Advantages: The generic platform driver is available for all
platforms, no need for dependencies in Kconfig.
Disadvantages: People who need clk_* must write a lot of code within
their board support file. Not nice and clean...

I'm ready to accept 1.) or 2.), or even both of them (why can't we have
two generic platform drivers?)

As you are the author (and probably user) of this driver, please decide,
and send a new patch for review.

Thanks,
Hans

