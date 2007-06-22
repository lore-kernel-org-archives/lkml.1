Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbXFVTtp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbXFVTtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 15:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751003AbXFVTth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 15:49:37 -0400
Received: from eazy.amigager.de ([213.239.192.238]:49513 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbXFVTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 15:49:36 -0400
Date: Fri, 22 Jun 2007 21:44:17 +0200
From: Tino Keitel <tino.keitel@gmx.de>
To: Alessandro Zummo <alessandro.zummo@towertech.it>,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Subject: Re: [rtc-linux] Re: rtc_cmos: error after first write to wakealarm
Message-ID: <20070622194417.GA19609@thinkpad.home.local>
Mail-Followup-To: Alessandro Zummo <alessandro.zummo@towertech.it>,
	linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
References: <20070615063308.GA18089@dose.home.local> <20070619172429.GA30990@dose.home.local> <20070622193431.71bed8b5@inspiron> <200706221145.53157.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706221145.53157.david-b@pacbell.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2007 at 11:45:52 -0700, David Brownell wrote:
> On Friday 22 June 2007, Alessandro Zummo wrote:
> > On Tue, 19 Jun 2007 19:24:29 +0200
> > Tino Keitel <tino.keitel@gmx.de> wrote:
> > 
> > > > > Where is the documentation that describes that I have to disable it
> > > > > first, and how to do this? A migration document for
> > > > > /proc/acpi/alarm users would be nice, too.
> > > > 
> > > >  Well, I guess there is no documentation. Maybe we could add
> > > >  a dev_warn with an explicit message.
> > > 
> > > Isn't it somewhat ridiculous to plan the removal of a feature for
> > > several months, and then replace it with something that behaves
> > > differently without any documentation?
> 
> It's got as much documentation in the kernel tree as that
> old /proc/acpi/alarm thing.  More, in fact, since the GIT
> comment for the putback creating /sys/rtc/.../wakealarm
> files has lots of info about how to use it.

What GIT comment are you referring to?

> 
> But sure, having documentation for the rtc sysfs interface
> would be a Fine Thing.  It should cover the other values
> too, not just that one attribute.
> 
> 
> > > I still wonder how 'cat /sys/class/rtc/rtcX/wakealarm' is expected to
> > > behave. With 2.6.22-rc5, I get this:
> > > 
> > > $ echo 1182351177 > /sys/class/rtc/rtc0/wakealarm 
> > > $ cat /sys/class/rtc/rtc0/wakealarm
> > > 2051644873
> > > 
> > > There seems to be a constant difference of 869984896 seconds. Is this a
> > > bug?
> 
> What RTC driver is that using?

rtc_cmos

> 
> One theory:  it's an RTC that doesn't support all the fields,
> so its driver is returning "-1" in fields like "year" or "month".

With the old /proc/acpi/alarm, the year 2007 became 0007. Maybe this is
the culprit?

Regards,
Tino
