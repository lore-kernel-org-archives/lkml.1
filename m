Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbXDPCBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbXDPCBB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 22:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbXDPCBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 22:01:00 -0400
Received: from mx34.mail.ru ([194.67.23.200]:9081 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754286AbXDPCBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 22:01:00 -0400
Date: Mon, 16 Apr 2007 05:57:05 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, linux-kernel@vger.kernel.org,
       kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: Re: [PATCH 3/7] [RFC] Battery monitoring class
Message-ID: <20070416015705.GA29933@zarina>
Reply-To: cbou@mail.ru
References: <20070411232503.GC20095@zarina> <20070415220854.GA20373@localhost.localdomain> <20070415225049.GA27680@zarina> <20070416005722.GA6296@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070416005722.GA6296@khazad-dum.debian.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 09:57:22PM -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 16 Apr 2007, Anton Vorontsov wrote:
> > Current battery class assumes values are not averaged. I.e. momentary
> > values. In general, it's userspace' job to collect statistics. Though,
> > if hardware can report only average values, it's just okay to use
> > usual attributes.
> 
> What about SBS-style battery firmware, which can report *both* ?  This
> includes just about all ThinkPads in the last five years, so we are talking
> about a damn big lot of machines...

Sure, no problem. I'm taking away my words "if hardware can report
only average values, it's just okay to use usual attributes", and replacing
them by "if hardware can report only average values, it should use _AVG
attributes".

So, this scheme should work now:

1. If userspace (nice GUI app) seeing _avg values, it will use these.
2. If userspace seeing no _avg values, it is using its own statistics
   mechanism, i.e. collecting information from momentary attributes.
3. If userspace seeing both, it can decide, most probably it will decide
   to use hardware averaged values, i.e. _avg.

> I'd really appreciate if there is a standard way to communicate both.  And
> it is probably a good idea to define what should be averaged, and what
> should be instantaneous when that matters, that way userspace actually has a
> chance at not doing something braindamaged.
> 
> Actually, IMHO, every attribute and alarm from SBS should be somehow
> losslessly translatable to standard class attributes from day one, unless it
> is something that makes no sense at all (and there is precious little of
> that in the latest version of SBS, thankfully...).
> 
> > Also, if you your battery can collect and report its approximated values
> > in additional to momentary values, you're free to add _AVG attributes
> > to standard ones and use them.
> 
> No, that won't help much.  IMO, we want the sanest set of standard
> attributes we can get, and weird as it might be, average reporting are
> common properties of battery control firmware on laptops (maybe because of
> SBS, but still...).

Why that won't help? Is there something else besides momentary and
hardware-averaged values?

> We don't have to get it perfect at the first try, but I really think we are
> getting a bit too far from "as good as we can make it" at the first attempt
> if we don't take the SBS into account properly, given the ammount of
> circuits and firmware out there that are shaped along the SBS guidelines.

I guess the only question for you is whether we would use, "attr" as momentary
and "attr_avg" as averaged by hardware value, or will use "attr" as averaged
values, and something alike "attr_now" for momentary? And you voting for
"attr" being averaged and "attr_now" momentary.

Actually, I don't see much difference, except default assumption of "attr"
being averaged/momentary.

Though, if it's real issue for you or SBS conformity, I can surely rename
attrs.

> -- 
>   "One disk to rule them all, One disk to find them. One disk to bring
>   them all and in the darkness grind them. In the Land of Redmond
>   where the shadows lie." -- The Silicon Valley Tarot
>   Henrique Holschuh
> 

And again, much thanks for your comments! They're really helpful.

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
