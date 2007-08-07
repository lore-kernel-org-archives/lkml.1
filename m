Return-Path: <linux-kernel-owner+w=401wt.eu-S1765522AbXHGMpE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765522AbXHGMpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 08:45:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbXHGMoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 08:44:54 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:2034 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759185AbXHGMow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 08:44:52 -0400
Date: Tue, 7 Aug 2007 14:45:12 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <1186415621.2706.4.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0708071417200.1817@scrub.home>
References: <15327.1186166232@lwn.net>  <Pine.LNX.4.64.0708032116340.1817@scrub.home>
  <1186170407.3153.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708032152060.1817@scrub.home>
  <1186185229.3153.11.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708040345530.1817@scrub.home>
  <1186255149.2777.3.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708060150270.1817@scrub.home>
  <1186360983.2697.8.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708060257010.1817@scrub.home>
  <1186378798.2697.10.camel@laptopd505.fenrus.org>  <Pine.LNX.4.64.0708061159370.1817@scrub.home>
 <1186415621.2706.4.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 6 Aug 2007, Arjan van de Ven wrote:

> So, let me ask a direct question: What do you think is specifically
> wrong about changing the msleep() implementation as is done here? The
> behavior is clearly an improvement, so what is your objection on the
> flipside?

Again, we have two different timer APIs for a reason - as long as you 
ignore this, we won't get much further...
As long as resolution is not an issue, simple timer are generally often 
the better choice as they are cheaper. By extension it also makes sense to 
offer a sleep based on simple timer.
hrtimer allows for finer resolution, so it makes more sense to offer a 
hrtimer based sleep which is not limited to milliseconds, once we have 
this sleep, you'll also get the better behaviour you're asking for, which 
removes the urgent need having to "fix" msleep.

Contrary to what you think I don't hate hrtimer, they're quite useful, but 
they have their use cases as simple timer have. What I want is that people 
_think_ before start using them, as in general hrtimer come with a higher 
base cost, so one should _think_ before thoughtlessly using them only 
because they're the cool new thing. I don't care much about drivers, but 
in generic code (which msleep is part of) I'm going to look closer and 
I'll continue to ask, whether it really needs to use hrtimer.
In this case I simply see no reason to force hrtimer on msleep, if users
can as well use nanosleep to get the same behaviour.

bye, Roman
