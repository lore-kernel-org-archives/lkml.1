Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbYIWLcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbYIWLcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 07:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYIWLcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 07:32:33 -0400
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:59892 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbYIWLcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 07:32:32 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LAe/szIHM2HptPDVUC/Zp
Date: Tue, 23 Sep 2008 14:32:16 +0300
From: Tony Lindgren <tony@atomide.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>, Alan Cox <alan@redhat.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: How to kick a secondary watchdog? (Re: [PATCH 1/3] watchdog:
	sync linux-omap changes)
Message-ID: <20080923113210.GM5102@atomide.com>
References: <1221873243-18303-1-git-send-email-me@felipebalbi.com> <1221873243-18303-2-git-send-email-me@felipebalbi.com> <20080922182206.GM22550@infomag.infomag.iguana.be> <20080922191353.GB8314@flint.arm.linux.org.uk> <20080923083915.GS22550@infomag.infomag.iguana.be> <20080923102159.GD5102@atomide.com> <20080923111954.GU22550@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923111954.GU22550@infomag.infomag.iguana.be>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Wim Van Sebroeck <wim@iguana.be> [080923 14:20]:
> Hi Tony,
> 
> > Wim, while at it, here's a related omap_wdt question:
> > 
> > Some omap devices like Nokia 770, N800 and N810 have also a secondary
> > watchdog on the retu chip connected via cbus. This watchdog needs
> > to be kicked as it cannot be disabled.
> > 
> > We've been thinking of adding a function that omap_wdt can
> > call to also kick retu_wdt too as there is only one wdt interface.
> > 
> > Is there some better solution available?
> 
> Plan is to go to a uniform watchdog driver first, then add sysfs
> capabilities and then we can add more devices via sysfs.
> For the time being: I would kick both of them at the same time
> via the /dev/watchdog interface.

Looks like we also need to do this for the twl4030 I2C companion chip
on omap 2430 and 34xx.

So we'll do something like this for now then:

static void omap_wdt_ping(struct omap_wdt_dev *wdev)
{

...

    retu_wdt_ping(wdev);
    twl4030_wdt_ping(wdev);
    
...

}

Then have retu_wdt_ping() and twl4030_wdt_ping() functions defined as
empty static inline functions if not enabled.

Thanks Alan & Wim.

Tony
