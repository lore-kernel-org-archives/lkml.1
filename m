Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbXBAAYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbXBAAYI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 19:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933376AbXBAAYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 19:24:08 -0500
Received: from smtp103.sbc.mail.mud.yahoo.com ([68.142.198.202]:29234 "HELO
	smtp103.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933331AbXBAAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 19:24:06 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RQ4SSShHHh/gM0FQRfTkbQfzqxadRj6UhTDgfdEBtHm+rnZG8XX0lrO8tMvn2+h21sOAbm3zIugdE1/vJG9gvT9f2XG0aydOT4fEYWSK1bTmoYqo0Hhqwem+rxCR7LLoss6BX9nHpUpI9+k9C0gMG68tbJELlM8cbRaFU7xtxzg=  ;
X-YMail-OSG: YiXJB4kVM1mIkDpDezJ1kcS4sAmzE6Dmk8.IHa1y7EfxxrOh
From: David Brownell <david-b@pacbell.net>
To: Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH 14/23] clocksource: increase initcall priority
Date: Wed, 31 Jan 2007 16:24:03 -0800
User-Agent: KMail/1.7.1
Cc: linux-kernel@vger.kernel.org
References: <20070131194311.4B8381FD833@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <1170283629.9781.163.camel@imap.mvista.com>
In-Reply-To: <1170283629.9781.163.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701311624.03735.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 January 2007 2:47 pm, Daniel Walker wrote:
> On Wed, 2007-01-31 at 11:43 -0800, David Brownell wrote:
> > > As a note, arm and mips both register their clocksources during
> > > time_init() instead of using initcalls.
> > 
> > That's actually platform-specific.  ...
> > 
> > So don't assume any platform doesn't use clocksource initcalls.
> 
> What does your OMAP clocksource do now ? 

OMAP being one family of ARMs ... well, maybe a few families
under the same branding umbrella.


> 	I thought one of the changes 
> that you made was to have both 32k and mpu both registered ..

Some OMAP1 chips will do that, if the MPU timer is configured *AND*
they have that 32K counter register.  Not OMAP2 (which doesn't have
MPU timers), and not the older OMAP1 chips (no 32K counter).

It turned out to be simpler to do it that way.  Otherwise the
configuration options get too confusing.  There are three types
of timer (MPU timers on most OMAP1 systems, 32K timer on some, dual
mode timers on newer chips including OMAP2) that can generate ticks.

In some cases, another of those timers wil also be used in free
run mode as a clocksource.  That 32K counter isn't a timer, but
it's a fine clocksource (if present).  But until clockevents go
upstream, it's kind of pointless to factor it all differently.

- Dave
