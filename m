Return-Path: <linux-kernel-owner+w=401wt.eu-S1761025AbXFVSqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761025AbXFVSqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759848AbXFVSpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:45:52 -0400
Received: from smtp105.sbc.mail.mud.yahoo.com ([68.142.198.204]:28956 "HELO
	smtp105.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753739AbXFVSpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:45:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aFS7oZ0DNq+7gHo1ERIcAkJKs2kqd7Zh8taOdmUFwsh3R4ahYV5RWeKawGjLth31COIAcnwm+vFgOCWbTtcCPJMc7lB9DnC8iqtrZ722rc95tWp2Rnn5imHdo8wQRiaW1EnWL7ZrkrpQVLxTuey3AGYuvj7SVSGgwvFCJR1a3k0=  ;
X-YMail-OSG: WE9vIHEVM1lFroHPFMxeiwAR48STHTbcitgW.kh5nYpsGjF4z9Njh.DPOqD9szgmBLmLF_vyCQ--
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: rtc_cmos: error after first write to wakealarm
Date: Fri, 22 Jun 2007 11:45:52 -0700
User-Agent: KMail/1.9.6
Cc: Tino Keitel <tino.keitel@gmx.de>, rtc-linux@googlegroups.com,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
References: <20070615063308.GA18089@dose.home.local> <20070619172429.GA30990@dose.home.local> <20070622193431.71bed8b5@inspiron>
In-Reply-To: <20070622193431.71bed8b5@inspiron>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706221145.53157.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, Alessandro Zummo wrote:
> On Tue, 19 Jun 2007 19:24:29 +0200
> Tino Keitel <tino.keitel@gmx.de> wrote:
> 
> > > > Where is the documentation that describes that I have to disable it
> > > > first, and how to do this? A migration document for
> > > > /proc/acpi/alarm users would be nice, too.
> > > 
> > >  Well, I guess there is no documentation. Maybe we could add
> > >  a dev_warn with an explicit message.
> > 
> > Isn't it somewhat ridiculous to plan the removal of a feature for
> > several months, and then replace it with something that behaves
> > differently without any documentation?

It's got as much documentation in the kernel tree as that
old /proc/acpi/alarm thing.  More, in fact, since the GIT
comment for the putback creating /sys/rtc/.../wakealarm
files has lots of info about how to use it.

But sure, having documentation for the rtc sysfs interface
would be a Fine Thing.  It should cover the other values
too, not just that one attribute.


> > I still wonder how 'cat /sys/class/rtc/rtcX/wakealarm' is expected to
> > behave. With 2.6.22-rc5, I get this:
> > 
> > $ echo 1182351177 > /sys/class/rtc/rtc0/wakealarm 
> > $ cat /sys/class/rtc/rtc0/wakealarm
> > 2051644873
> > 
> > There seems to be a constant difference of 869984896 seconds. Is this a
> > bug?

What RTC driver is that using?

One theory:  it's an RTC that doesn't support all the fields,
so its driver is returning "-1" in fields like "year" or "month".

Right now there's no code forcing rtc_read_alarm() to return
values for which rtc_valid_tm(&alarm->time), and bogus values
in wakealarm would be a symptom.  I suspect most of the systems
I tested the "wakealarm" attribute with have RTC alarms that
don't have those particular deficiencies.

- Dave

> 
>  I'll have to check that. Sorry for the delay, i've been a bit busy.
> 
> 
> -- 
> 
