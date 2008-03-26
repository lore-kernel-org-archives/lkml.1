Return-Path: <linux-kernel-owner+w=401wt.eu-S1758391AbYCZQsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391AbYCZQsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 12:48:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYCZQrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 12:47:55 -0400
Received: from tim.rpsys.net ([194.106.48.114]:45919 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbYCZQry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 12:47:54 -0400
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <david-b@pacbell.net>, gitster@pobox.com, corbet@lwn.net,
       mingo@elte.hu, mb@bu3sch.de, linux-kernel@vger.kernel.org,
       khali@linux-fr.org, geert@linux-m68k.org, akpm@linux-foundation.org
In-Reply-To: <20080326161724.GA3562@khazad-dum.debian.net>
References: <20080325232042.4EDA7346532@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
	 <Pine.LNX.4.44L0.0803261027580.4969-100000@iolanthe.rowland.org>
	 <20080326161724.GA3562@khazad-dum.debian.net>
Content-Type: text/plain
Date: Wed, 26 Mar 2008 16:46:09 +0000
Message-Id: <1206549969.13642.6.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-26 at 13:17 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 26 Mar 2008, Alan Stern wrote:
> > On Tue, 25 Mar 2008, David Brownell wrote:
> > > I _almost_ hate bringing this lovely flamage back onto $SUBJECT ... but
> > > what's the resolution for the leds-gpio.c issue?  I've not seen a merge
> > > notice for the patch I submitted a week ago now:
> > > 
> > > 	http://marc.info/?l=linux-kernel&m=120597839009399&w=2
>
[...]
> I have changed the thinkpad-acpi leds code to always assume an atomic
> context, but I too would appreciate a proper flag (or secondary hook)
> from the LED class to know when I am in an atomic context or not.
> 
> LED Triggers also need to be modified, they are mostly called from an
> atomic context so we have to assume that by default, but we'd do well to
> add a way to call them from non-atomic contexts.
> 
> Richard?  AFAIK, the ball *is* in your court as the LED maintainer.  You
> have to decide which way to go and tell us.  I suppose either I or Alan
> could write up patches to implement it, but I have better things to do
> than to write patches that would be rejected anyway... OTOH, I don't
> mind writing ones that I know are at least attempting to implement an
> approved idea and would be rejected only if they need some fixing.

I've been meaning to merge David's patch and will get that done shortly,
sorry for the delay.

As I've said, I don't really think we need context flags for the LED
class at the moment. As you say, most of the triggers are atomic context
and those which can sleep are not time critical so I don't really see
the point in the added complexity.

Cheers,

Richard


