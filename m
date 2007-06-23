Return-Path: <linux-kernel-owner+w=401wt.eu-S1751483AbXFWDTD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483AbXFWDTD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 23:19:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFWDSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 23:18:53 -0400
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.208]:48777 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751003AbXFWDSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 23:18:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=UwdqqUip6esz95df+oTC/i4Y5HGppNN/+VzkL6yW+IqMK58atPSlinbXxbqVYlXh5+2gfjXOhTi32uonybA1a64F1f8u4Y/6yCHpuKrS0qwMltZ+AfpzPRhZLkf7xA8EQHTZCPgymq+qpGPMIobNrZlRe7CifOiX8b5+DV1Xv6Y=  ;
X-YMail-OSG: hDipHc4VM1mIzzB5BFW4RVjESlRZarzyr821ABLEAgu8g7xwyjMFFTg93pr4tlkSTVMn3spz5g--
From: David Brownell <david-b@pacbell.net>
To: Tino Keitel <tino.keitel@gmx.de>
Subject: Re: [rtc-linux] Re: rtc_cmos: error after first write to wakealarm
Date: Fri, 22 Jun 2007 20:18:53 -0700
User-Agent: KMail/1.9.6
Cc: Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       linux-kernel@vger.kernel.org
References: <20070615063308.GA18089@dose.home.local> <20070622193431.71bed8b5@inspiron> <200706221145.53157.david-b@pacbell.net>
In-Reply-To: <200706221145.53157.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706222018.54196.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ please don't edit folk off the cc list unless you *know* they
are getting duplicates ... ]

> > It's got as much documentation in the kernel tree as that
> > old /proc/acpi/alarm thing.  More, in fact, since the GIT
> > comment for the putback creating /sys/rtc/.../wakealarm
> > files has lots of info about how to use it.
> 
> What GIT comment are you referring to?

What "git log drivers/rtc/rtc-sysfs.c" shows ... date Feb 12.
The web interface shows it too.


> > One theory:  it's an RTC that doesn't support all the fields,
> > so its driver is returning "-1" in fields like "year" or "month".
>
> With the old /proc/acpi/alarm, the year 2007 became 0007. Maybe this is
> the culprit?

That's essentially the same issue.  It needs some sort
of generic fix at the rtc_read_alarm() level.


