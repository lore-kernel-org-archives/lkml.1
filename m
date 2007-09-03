Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXICKHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXICKHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 06:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752256AbXICKHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 06:07:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40296 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428AbXICKHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 06:07:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: cpu hotplug support broken in 2.6.23-rc3
Date: Mon, 3 Sep 2007 12:19:12 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Chua <jeff.chua.linux@gmail.com>, rusty@rustycorp.com.au,
       vatsa@in.ibm.com, zwane@arm.linux.org.uk,
       kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20070827104350.GA2073@elf.ucw.cz> <b6a2187b0708280721w20d5dc44q249642f7946ae55a@mail.gmail.com> <20070903034720.GB3655@ucw.cz>
In-Reply-To: <20070903034720.GB3655@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709031219.12846.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 3 September 2007 05:47, Pavel Machek wrote:
> Hi!
> 
> > > Can you try 20-or-so tests? Mine hangs randomly, so it survived 4 or
> > > so cycles at one point.
> > 
> > Mine still survives with this ... with sleep 1 ...
> > 
> > # for((i=0; i<100; i++)); do echo $i; echo $((i % 2))
> > >/sys/devices/system/cpu/cpu1/online; sleep 1; done
> > 
> > and this as well ... without sleep ...
> > 
> > # for((i=0; i<100; i++)); do echo $i; echo $((i % 2))
> > >/sys/devices/system/cpu/cpu1/online; done
> > 
> > I'm on reiserfs. gcc 3.4.5. Config sent to you seperately so as not to
> > cloud lkml. If anyone wants the config, please let me know. Is mime
> > "attachment" acceptable now on lkml?
> 
> Ok, so it gets weirder. I have now machine in "hung" state; other
> consoles still work, but there are no timers -  sleep 1 hangs forever.
> 
> sysrq-t shows kstopmachine hung in hrtimer_try_to_cancel.
> 
> So I indeed suspect difference-in-kconfig to trigger this, and will
> try disabling noidlehz.

I would unset CONFIG_HIGH_RES_TIMERS for starters.

Well, I guess Thomas should know about that. ;-)

Greetings,
Rafael
