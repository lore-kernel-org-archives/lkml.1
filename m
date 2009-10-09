Return-Path: <linux-kernel-owner+w=401wt.eu-S933938AbZJIQkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbZJIQkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 12:40:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbZJIQko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 12:40:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:48433 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758882AbZJIQkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 12:40:43 -0400
Date: Fri, 9 Oct 2009 09:32:02 -0700
From: Greg KH <gregkh@suse.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
Message-ID: <20091009163202.GA3342@suse.de>
References: <4ACD0E5A.7060106@oracle.com>
 <1254954842.3713.7.camel@johannes.local>
 <4ACD1C3D.3030506@oracle.com>
 <1254957256.3713.10.camel@johannes.local>
 <20091007171235.d40f0cc2.randy.dunlap@oracle.com>
 <1254995282.3713.18.camel@johannes.local>
 <20091008080615.09c8b803.randy.dunlap@oracle.com>
 <1255026563.3713.28.camel@johannes.local>
 <20091009090601.73de5dc6.randy.dunlap@oracle.com>
 <1255104846.4095.2.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255104846.4095.2.camel@johannes.local>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09, 2009 at 06:14:06PM +0200, Johannes Berg wrote:
> On Fri, 2009-10-09 at 09:06 -0700, Randy Dunlap wrote:
> 
> > >  menuconfig WLAN
> > >  	bool "Wireless LAN"
> > >  	depends on !S390
> > > +	select WIRELESS
> > >  	default y
> > >  	---help---
> > >  	  This section contains all the pre 802.11 and 802.11 wireless
> > 
> > 
> > I suppose that's OK, although I prefer "depends" rather than "select".
> 
> I tend to as well, but in this case the WIRELESS itself is just an
> option that makes other options invisible, it's not used elsewhere, and
> as such I think this is ok -- why hide the wireless drivers unless the
> user first selects the wireless core options?
> 
> OTOH, you already need to select cfg80211/mac80211 for most drivers, so
> I suppose "depends on WIRELESS" would be ok too.
> 
> > I tracked down one of the problems that I was seeing:
> > 
> > net/wireless/wext-priv.c:206: error: implicit declaration of function 'call_commit_handler'
> > 
> > with:
> > # CONFIG_WIRELESS is not set
> > CONFIG_WIRELESS_EXT=y
> > CONFIG_WEXT_PRIV=y
> > 
> > This is being caused by several drivers in drivers/staging/ doing
> > 	select WEXT_PRIV
> > without using either enough dependencies or even more (ugly) selects.
> > (or just because kconfig isn't sufficient)
> 
> Hah, staging/, well, that's kinda hard to solve I guess. Except by
> fixing all the staging/ drivers to depend on WIRELESS too, like the
> patch would do for the regular drivers.

That's fine, I'll gladly take patches to do that.

thanks,

greg k-h
