Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZA3Ji5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZA3Ji5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 04:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbZA3Jis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 04:38:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35563 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbZA3Jir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 04:38:47 -0500
Date: Fri, 30 Jan 2009 10:38:46 +0100
From: Pavel Machek <pavel@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Sandro Bonazzola <sandro.bonazzola@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Bruno Randolf <br1@einfach.org>
Subject: Re: [PATCH] w35und: fix registration with wlan stack
Message-ID: <20090130093846.GC9495@atrey.karlin.mff.cuni.cz>
References: <497F5FEA.7020203@gmail.com> <20090127200602.GA16444@elf.ucw.cz> <4980B2DD.307@gmail.com> <4980BB9A.2020309@cs.helsinki.fi> <4980C028.2030709@gmail.com> <4980C035.4070105@cs.helsinki.fi> <4980DB5D.6010906@gmail.com> <20090130090525.GA1997@elf.ucw.cz> <1233306825.13655.28.camel@penberg-laptop> <1233306980.4161.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233306980.4161.19.camel@johannes.local>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 2009-01-30 at 11:13 +0200, Pekka Enberg wrote:
> 
> 
> > >  	dev->extra_tx_headroom = 12;	/* FIXME */
> > > -	dev->flags = 0;
> > > +	dev->flags = IEEE80211_HW_SIGNAL_UNSPEC;
> > > +	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
> > 
> > The wiphy->interface_modes thing is probably fall-out from commit
> > 8dffff216fcac4f79078478085e86d68db64922e ("mac80211: only create default
> > STA interface if supported"). I'm cc'ing Johannes.
> 
> Yes. That looks reasonable, though it means you'll only support STA, not
> ad-hoc.

Ok. The driver is very basic for now (can only do channel 1), so we
certainly have bigger problems than ad-hoc.

> > >  	dev->channel_change_time = 1000;
> > > +	dev->max_signal = 100;
> > 
> > And the IEEE80211_HW_SIGNAL_UNSPEC and ->max_signal from commit
> > 566bfe5a8bcde13188a356f77666f8115813cf31 ("mac80211: use hardware flags
> > for signal/noise units"). Lets cc Bruno.
> 
> Seems reasonable, though does it would be good to see if it can do DBM,
> which we very very much prefer.

Well, currenlty it reports all zeros...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
