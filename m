Return-Path: <linux-kernel-owner+w=401wt.eu-S1755259AbZAETre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259AbZAETre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 14:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZAETrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 14:47:25 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58521 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752652AbZAETrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 14:47:24 -0500
Date: Mon, 5 Jan 2009 19:47:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Newall <davidn@davidnewall.com>
Cc: Chris Adams <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years
 2008-2009
Message-ID: <20090105194720.58406f8a@lxorguk.ukuu.org.uk>
In-Reply-To: <4961C83A.6020009@davidnewall.com>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	<20090102210430.49649261@diego-desktop>
	<495E7849.4030706@shaw.ca>
	<495F0672.6020708@davidnewall.com>
	<8752a8760901022237r75d408b3i74c703c8ac2d4597@mail.gmail.com>
	<496076A9.7030907@davidnewall.com>
	<f73f7ab80901040100i78148513s75c6276722a76661@mail.gmail.com>
	<4960897D.5030603@davidnewall.com>
	<alpine.DEB.1.10.0901040310070.24563@asgard.lang.hm>
	<4961432A.80509@davidnewall.com>
	<20090104232534.GB1297917@hiwaay.net>
	<49614DD8.7070707@davidnewall.com>
	<20090105004123.374709ff@lxorguk.ukuu.org.uk>
	<4961C83A.6020009@davidnewall.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > For any given time based on the 1970 Epoch there is a single correct
> > answer for the translation between each value and a UTC time.
> 
> This confused me because the sense that I've got from this thread
> suggests otherwise.  Unless I've misunderstood, the time() value for the
> first second of 2009 is one greater than the value for the second to
> last second of 2008 (i.e. 23:59:59), which means that there is no
> translation for the last second.  Put another way, my understanding of
> what's been said is that the epoch is effectively increased by one
> second for each leap second.  Have I got this wrong?

No I should have said from a UTC time to a value, the reverse is slightly
ambiguous - as you say leap seconds cannot be distinguished (well unless
you are using floating point but thats a whole can of worms)

Glibc has /usr/share/zoneinfo/right as well as posix zones which I guess
is Ulrich's vote on the subject.

In a strictly posix environment then for 1003.1 post 2001 the definition
is non-leap seconds since (a notional) 1/1/70 UTC 00:00:00. Including
leap seconds in the definition would have caused problems with existing
date stamps moving them by about half a minute.

The kernel doesn't give a brass monkeys about interpretation on the whole
with one main exception - the CMOS RTC time conversion is done without
factoring in leap seconds.

Alan
