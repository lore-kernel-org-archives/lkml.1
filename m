Return-Path: <linux-kernel-owner+w=401wt.eu-S933258AbXCMU1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933258AbXCMU1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXCMU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:27:33 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:52866
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258AbXCMU1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:27:32 -0400
Date: Tue, 13 Mar 2007 13:27:26 -0700
To: David Schwartz <davids@webmaster.com>
Cc: jeremy@goop.org,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>,
       Con Kolivas <kernel@kolivas.org>
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
Message-ID: <20070313202726.GA9520@gnuppy.monkey.org>
References: <45F6E69B.9000602@goop.org> <MDEHLPKNGKAHNMBLJOLKIELACDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKIELACDAC.davids@webmaster.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2007 at 12:58:01PM -0700, David Schwartz wrote:
> > But saying that the user needs to explicitly hold the schedulers hand
> > and nice everything to tell it how to schedule seems to be an abdication
> > of duty, an admission of failure.  We can't expect users to finesse all
> > their processes with nice, and it would be a bad user interface to ask
> > them to do so.
> 
> Then you will always get cases where the scheduler does not do what the user
> wants because the scheduler does not *know* what the user wants. You always
> have to tell a computer what you want it to do, and the best it can do is
> faithfully follow your request.
> 
> I think it's completely irrational to ask for a scheduler that automatically
> gives more CPU time to CPU hogs.

SGI machines had an interactive term in their scheduler as well as a
traditional nice priority. It might be useful for Con to possibly consider
this as an extension for problematic (badly hacked) processes like X.

Nice as a control mechanism is rather coarse, yet overly strict because of
the sophistication of his scheduler. Having an additional term (control knob)
would be nice for a scheduler that is built upon (correct me if I'm wrong Con):

1) has rudimentary bandwidth control for a group of runnable processes
2) has a basic deadline mechanism

The "nice" term is only an indirect way of controlling his scheduler and
think and this kind of imprecise tweeking being done with various apps is an
indicator of how lacking it is as a control term in the scheduler. It would
be good to have some kind of coherent and direct control over the knobs that
are (1) and (2).

Schedulers like this have superior control over these properties and they
should be fully exploited with terms in additional to "nice".

Item (1) is subject to a static "weight" multiplication in relation to other
runnable tasks. It also might be useful to make a part of that term a bit
dynamic to get some kind of interactivity control back. It's a matter of
testing, tweeking, etc... and are not easy for apps that don't have a
direct thread context to control like a thread unaware X system.

> > And if someone/distro *does* go to all the effort of managing how to get
> > all the processes at the right nice levels, you have this big legacy
> > problem where you're now stuck keeping all those nice values meaningful
> > as you continue to develop the scheduler.  Its bad enough to make them
> > do the work in the first place, but its worse if they need to make it a
> > kernel version dependent function.
> 
> I agree. I'm not claiming to have the perfect solution. Let's not let the
> perfect be the enemy of the good though.

I hope this was useful.

bill

