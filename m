Return-Path: <linux-kernel-owner+w=401wt.eu-S1764396AbYEHRNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764396AbYEHRNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 13:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755823AbYEHRNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 13:13:25 -0400
Received: from rtsoft2.corbina.net ([85.21.88.2]:51739 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1755351AbYEHRNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 13:13:24 -0400
Date: Thu, 8 May 2008 21:13:20 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Andres Salomon <dilinger@queued.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, cbou@mail.ru,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org, richard@laptop.org
Subject: Re: [PATCH] power_supply: support CHARGE_NOW in OLPC battery
Message-ID: <20080508171320.GA8226@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080508003454.722ba511@ephemeral> <20080508105145.GA32017@polina.dev.rtsoft.ru> <20080508130102.3218f1e9@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20080508130102.3218f1e9@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 01:01:02PM -0400, Andres Salomon wrote:
> Ok, CC'ing Richard as I should've done in the first place...
[...]
> > > +	case POWER_SUPPLY_PROP_CHARGE_NOW:
> > > +		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void
> > > *)&ec_word, 2);
> > > +		if (ret)
> > > +			return ret;
> > > +
> > > +		val->intval = be16_to_cpu(ec_word);
> > 
> > But you didn't convert it to the uAh, I think you should.
> 
> 
> We have logic in userspace that converts ACR to a useful number; for
> our purposes, we'd just like to read the raw ACR values.

No. The purpose of power supply class is to report values in common
units. Not some random value that userspace then should guess how to
compute.

> Perhaps CHARGE_NOW is the wrong thing to be using, if we can't get
> uAh and CHARGE_* requires that unit.

I don't think that converting X * uAh or uAh / Y to uAh is impossible.
I'd suggest you to convert the ACR value to uAh using fractions, see
ds2760_battery.c. Even if the final value losing precision a bit, it is
still useful to do CHARGE_NOW.

Of course, additionally you can create your own private attribute
which reports raw value, if this is anyhow useful.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
