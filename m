Return-Path: <linux-kernel-owner+w=401wt.eu-S1752910AbYISVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910AbYISVen (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYISVeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:34:08 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:57057 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYISVeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:34:05 -0400
Date: Sat, 20 Sep 2008 00:33:34 +0300
From: Felipe Balbi <me@felipebalbi.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Felipe Balbi <felipe.balbi@nokia.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
Subject: Re: [PATCH 5/5] watchdog: introduce platform_data and remove cpu
	conditional code
Message-ID: <20080919213331.GA10156@frodo>
Reply-To: me@felipebalbi.com
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-5-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-6-git-send-email-felipe.balbi@nokia.com> <20080919190431.GA9675@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080919190431.GA9675@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 08:04:32PM +0100, Russell King - ARM Linux wrote:
> On Fri, Sep 19, 2008 at 01:32:39PM +0300, Felipe Balbi wrote:
> > @@ -469,17 +515,26 @@ static struct platform_device omap_wdt_device = {
> >  
> >  static void omap_init_wdt(void)
> >  {
> > -	if (cpu_is_omap16xx())
> > +	if (cpu_is_omap16xx()) {
> > +		omap_wdt_pdata.fck = "armwdt_ck";
> >  		wdt_resources[0].start = 0xfffeb000;
> > -	else if (cpu_is_omap2420())
> > +	} else if (cpu_is_omap2420()) {
> > +		omap_wdt_pdata.fck = "mpu_wdt_ick";
> > +		omap_wdt_pdata.ick = "mpu_wdt_fck";
> 
> What happened to leaving this stuff inside omap_wdt.c as I said
> during the previous review?  I really don't want to see such cleanups
> when the real answer is to fix the OMAP clock API implementation.  It
> just makes for more unnecessary noise when doing this, and then yet more
> noise when we fix the OMAP clock API.
> 
> Please get rid of this and leave the clock naming crap inside omap_wdt.c.

Well, patches 4 and 5 should be ignored. Should I resend or could I rely
on the fact that people won't pick them up ?

-- 
balbi
