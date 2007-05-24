Return-Path: <linux-kernel-owner+w=401wt.eu-S1758114AbXEXJdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114AbXEXJdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 05:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756046AbXEXJdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 05:33:17 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:55158 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbXEXJdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 05:33:16 -0400
Date: Thu, 24 May 2007 18:32:22 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Daniel Newby <daniel.a.newby@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: how to allow board writers to customize driver behavior (watchdog here)
Message-ID: <20070524093222.GA3452@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Daniel Newby <daniel.a.newby@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <8bd0f97a0705232121j32fcff72hd04b04e37507450e@mail.gmail.com> <20070524052312.GA2447@linux-sh.org> <ba1ee50c0705240147t3d2ebf43w8cb0335bc7c239e4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba1ee50c0705240147t3d2ebf43w8cb0335bc7c239e4@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2007 at 03:47:45AM -0500, Daniel Newby wrote:
> On 5/24/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > It sounds like your constraining your driver based on terminology.
> >Watchdogs on most embedded platforms support either a 'reset' mode or
> >otherwise act as periodic timers, trying to push both of these
> >functionalities in to a watchdog driver is rather pointless.
> >CONFIG_WATCHDOG implies 'reset' mode by definition.
> 
> I agree for a product in the hands of a customer:  let the watchdog
> pull your bacon out of the fire.
> 
> But what about debugging?  Suppose your embedded computer with custom
> drivers locks up solid every few hundred hours.  It would be nice if
> the watchdog gave a stack dump instead erasing the evidence.  How about
> having "action=reset" and "action=debug"?
> 
Again, CONFIG_WATCHDOG implies reset by definition. If you'd like to
propose pluggable policies for CONFIG_WATCHDOG and post the code for
that, go right ahead.

For soft lockups, there's already the softlockup code which does what
you seem to be leaning towards. For hard lockups (which is where
CONFIG_WATCHDOG comes in handy), you're likely not going to get any
output anyways. In either case, wiggling this in to CONFIG_WATCHDOG is
very much changing the meaning of what CONFIG_WATCHDOG means today, and
doesn't seem to buy us anything.
