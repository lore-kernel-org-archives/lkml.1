Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbZAFT5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbZAFT5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbZAFT5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:57:03 -0500
Received: from bsdimp.com ([199.45.160.85]:64343 "EHLO harmony.bsdimp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbZAFT5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:57:01 -0500
X-Greylist: delayed 406 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Jan 2009 14:57:00 EST
Date: Tue, 06 Jan 2009 12:40:55 -0700 (MST)
Message-Id: <20090106.124055.143671472.imp@bsdimp.com>
To: linasvepstas@gmail.com
Cc: johnstul.lkml@gmail.com, david@lang.hm, goodgerster@gmail.com,
       kyle@moffetthome.net, slashdot@jameshallam.info, zippel@linux-m68k.org,
       davidn@davidnewall.com, linux-kernel@vger.kernel.org, hancockr@shaw.ca,
       ntpwg@lists.ntp.isc.org, pretzalz@techhouse.org,
       burdell@iruntheinter.net, nick@nick-andrew.net, jeff@kosowsky.org
Subject: Re: [ntpwg] Bug: Status/Summary of slashdot leap-second crash on
 new years 2008-2009
From: "M. Warner Losh" <imp@bsdimp.com>
In-Reply-To: <3ae3aa420901052053m5a410671u13ecccfb7e29260c@mail.gmail.com>
References: <3ae3aa420901050942y56f0ecdei39c091a73e49c1fd@mail.gmail.com>
	<1f1b08da0901051827r57158990ic795208ba37120ad@mail.gmail.com>
	<3ae3aa420901052053m5a410671u13ecccfb7e29260c@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message: <3ae3aa420901052053m5a410671u13ecccfb7e29260c@mail.gmail.com>
            "Linas Vepstas" <linasvepstas@gmail.com> writes:
: 2009/1/5 john stultz-lkml <johnstul.lkml@gmail.com>:
: > On Mon, Jan 5, 2009 at 9:42 AM, Linas Vepstas <linasvepstas@gmail.com> wrote:
: > [snip]
: >> The long term solution would be write an RFC to extend
: >> NTP to also provide TAI information -- e.g. to add a
: >> message that indicates the current leap-second offset
: >> between UTC and TAI.
: >
: > I believe Roman has already added this ability:
: > http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=153b5d054ac2d98ea0d86504884326b6777f683d;hp=9f14f669d18477fe3df071e2fa4da36c00acee8e
: 
: Well, you're answering a different statment than what
: I was talking about -- I wanted to make sure that TAI
: information was available via NTP -- this has nothing
: to do with the kernel, and would be something available
: to all operating systems.
: 
: Anyway -- I'm looking at the patch you reference, and
: maybe I'm being dumb -- but -- I think I see a bug.
: 
: case TIME_DEL decrements TAI, but TIME_INS does
: not increment it. Instead, there's a lonely increment in
: TIME_OOP which seems wrong.  ??

No.  That's right.  The increment doesn't happen until the leap second
has happened.  The TIME_OOP exists to increment the TAI offset at the
right time.  The decrement would happen right away, since the second
is deleted at the end of :58.

I had to draw lots of pictures when I was working this code out in
FreeBSD.

Warner
