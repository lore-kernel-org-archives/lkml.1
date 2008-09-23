Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbYIWKWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbYIWKWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 06:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYIWKWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 06:22:16 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59980 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbYIWKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 06:22:16 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/rm4AspQWShZ03TBW8ckkn
Date: Tue, 23 Sep 2008 13:22:00 +0300
From: Tony Lindgren <tony@atomide.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: How to kick a secondary watchdog? (Re: [PATCH 1/3] watchdog: sync
	linux-omap changes)
Message-ID: <20080923102159.GD5102@atomide.com>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com> <1221873243-18303-2-git-send-email-me@felipebalbi.com> <20080922182206.GM22550@infomag.infomag.iguana.be> <20080922191353.GB8314@flint.arm.linux.org.uk> <20080923083915.GS22550@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923083915.GS22550@infomag.infomag.iguana.be>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wim Van Sebroeck <wim@iguana.be> [080923 11:39]:
> Hi Russell,
> 
> > It's unused, but it's a minor point, something that shouldn't stand
> > in the way of it going into the watchdog tree.  It doesn't cause a
> > build error and doesn't cause malfunction.  It's just a little untidy
> > and can be addressed separately.
> 
> We will need to address it later then. I just added the patches to the
> linux-2.6-watchdog-mm tree.
> 
> > +               omap_wdt_set_timeout(wdev);
> > +               omap_wdt_enable(wdev);
> >                 spin_unlock(&wdt_lock);
> > +
> > +               omap_wdt_ping(wdev);
> > 
> > which is moving omap_wdt_ping() outside of the spin lock, which I
> > doubt actually causes any problem in real life on OMAP platforms.
> > Granted that theoretically and logically it's wrong.
> 
> And since this is indeed wrong, I changed this back.

Wim, while at it, here's a related omap_wdt question:

Some omap devices like Nokia 770, N800 and N810 have also a secondary
watchdog on the retu chip connected via cbus. This watchdog needs
to be kicked as it cannot be disabled.

We've been thinking of adding a function that omap_wdt can
call to also kick retu_wdt too as there is only one wdt interface.

Is there some better solution available?

Regards,

Tony
