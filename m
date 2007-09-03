Return-Path: <linux-kernel-owner+w=401wt.eu-S1754902AbXICJ4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902AbXICJ4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXICJ40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:56:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46162 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbXICJ4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:56:25 -0400
Date: Mon, 3 Sep 2007 03:47:20 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: rusty@rustycorp.com.au, vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Message-ID: <20070903034720.GB3655@ucw.cz>
References: <20070827104350.GA2073@elf.ucw.cz> <20070827105801.GA4053@elf.ucw.cz> <b6a2187b0708270736q5cfc180fp3c223a57ea6904f9@mail.gmail.com> <20070827213248.GF3398@elf.ucw.cz> <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> > so cycles at one point.
> 
> Mine still survives with this ... with sleep 1 ...
> 
> # for((i=0; i<100; i++)); do echo $i; echo $((i % 2))
> >/sys/devices/system/cpu/cpu1/online; sleep 1; done
> 
> and this as well ... without sleep ...
> 
> # for((i=0; i<100; i++)); do echo $i; echo $((i % 2))
> >/sys/devices/system/cpu/cpu1/online; done
> 
> I'm on reiserfs. gcc 3.4.5. Config sent to you seperately so as not to
> cloud lkml. If anyone wants the config, please let me know. Is mime
> "attachment" acceptable now on lkml?

Ok, so it gets weirder. I have now machine in "hung" state; other
consoles still work, but there are no timers -  sleep 1 hangs forever.

sysrq-t shows kstopmachine hung in hrtimer_try_to_cancel.

So I indeed suspect difference-in-kconfig to trigger this, and will
try disabling noidlehz.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
