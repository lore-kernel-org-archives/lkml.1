Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbXEYLi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbXEYLi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 07:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbXEYLiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 07:38:51 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45460 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXEYLiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 07:38:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: pcmcia resume 60 second hang. Re: [patch 00/69] -stable review
Date: Fri, 25 May 2007 13:44:03 +0200
User-Agent: KMail/1.9.5
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       Chris Wright <chrisw@sous-sol.org>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
References: <1179870110.16656.2.camel@localhost> <20070524231638.GC29678@khazad-dum.debian.net> <20070524231950.GH9604@elf.ucw.cz>
In-Reply-To: <20070524231950.GH9604@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705251344.04738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 25 May 2007 01:19, Pavel Machek wrote:
> On Thu 2007-05-24 20:16:38, Henrique de Moraes Holschuh wrote:
> > On Fri, 25 May 2007, Pavel Machek wrote:
> > > My proposed solution is "fix pcmcia to load firmware before suspend
> > > even starts"
> > 
> > s/pcmcia/all drivers that load firmware/ if you are going to go that way.
> 
> I'm not "going that way". It always was that way. If driver tries to
> load firmware during suspend, it will deadlock.

Exactly.

And the freezing of user land has _nothing_ to do with that.  The fact is
the user land is not reliable while device drivers are being suspended,
regardless of whether it's frozen at that point or not.

BTW, we are going (or at least I'm going) to untangle the hibernation and
suspend code paths, but I have limited time for that and I just _can't_ do this
any faster.  In the meantime, we have bugs like this one that need to be fixed
_within_ the current limitations, because we just _can't_ remove these
limitations overnight..

Greetings,
Rafael
