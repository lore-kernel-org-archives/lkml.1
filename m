Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZF3Phg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZF3Phg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 11:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbZF3PhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 11:37:18 -0400
Received: from ru.mvista.com ([213.79.90.228]:21598 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753307AbZF3PhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 11:37:17 -0400
Date: Tue, 30 Jun 2009 19:37:19 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@collabora.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>, cbou@mail.ru,
       dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
 and use it for olpc driver
Message-ID: <20090630153719.GA13300@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20090630021730.44f86185@mycelium.queued.net>
 <20090630113135.GD13961@sirena.org.uk>
 <20090630110430.6c7c5cdf@mycelium.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20090630110430.6c7c5cdf@mycelium.queued.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 11:04:30AM -0400, Andres Salomon wrote:
> On Tue, 30 Jun 2009 12:31:35 +0100
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Tue, Jun 30, 2009 at 02:17:30AM -0400, Andres Salomon wrote:
> > 
> > > This adds a new sysfs file called 'charge_type' which displays the
> > > type of charging (n/a, trickle charge, slow charge, or fast
> > > charging).  This allows things like battery diagnostics to
> > > determine what the battery/EC is doing without resorting to
> > > changing the 'status' sysfs output.
> > 
> > > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> > 
> > This looks good to me.  Could you please keep me on the CC for any
> > future revisions of this patch, I can make use of this in the WM8350
> > driver.
> 
> Sure.
> 
> > 
> > > +	static char *charge_type[] = {
> > > +		"N/A", "Trickle", "Slow", "Fast"
> > > +	};
> > 
> > I'd be tempted to make "N/A" be "Unknown" to match the style of the
> > rest of the attributes.  I'm also not sure that we need a slow type,
> > but equally it shouldn't do any harm.
> 
> 
> It's known though, right? :)   It could just as easily be "None",
> "Unknown", etc, but I'm not particularly picky.

These are quite different states, and thinking about it, we might
want to introduce both. Default is "Unknown" (0), means that the
driver can't report the charging mode at this very moment. And "N/A"
is "not applicable", i.e. we're not charging anything right now.

> As far as the slow type, I don't see the need either, but I assumed
> Anton was aware of devices that differentiated between slow and
> trickle charging.

Yep, there are two charging modes in Openmoko Neo FreeRunners:

- 100 mA. It's "slow" mode -- used when the Neo couldn't negotiate
  with USB host, so it is permitted to only draw 100 mA from VBUS.

- 500/1000 mA. It's so-called "fast" mode, can be enabled after
  successful negotiation with the USB host.


Well, this kind slow charging isn't official terminology, and
I'm not sure if we should use it. But I'm fine with it since we
can always remove "Slow" mode (i.e. report it as "Fast"), and
userspace won't break.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
