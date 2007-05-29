Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbXE2QbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbXE2QbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 12:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753937AbXE2QbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 12:31:03 -0400
Received: from THUNK.ORG ([69.25.196.29]:49272 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbXE2QbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 12:31:01 -0400
Date: Tue, 29 May 2007 12:30:56 -0400
From: Theodore Tso <tytso@mit.edu>
To: Pavel Machek <pavel@ucw.cz>
Cc: M Macnair <mmacnair@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Seeding /dev/random not working
Message-ID: <20070529163056.GE9899@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
	M Macnair <mmacnair@gmail.com>, linux-kernel@vger.kernel.org
References: <de6d2b4f0705290453kec2b050pb4d0bebc256b87a5@mail.gmail.com> <20070529131501.GA9899@thunk.org> <20070529141456.GC5840@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529141456.GC5840@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2007 at 02:14:56PM +0000, Pavel Machek wrote:
> Can we get at least time-of-boot from rtc clock to the pool? We really
> should not be getting identical outputs...

We are mixing the time-of-dat at boot time into the pool already,
using ktime_get_real() in random.c:init_std_data().  The problem
though is if the board doesn't have a valid RTC clock, or its battery
is dead, and the time-of-day clock is getting set by userspace, then
unless userspace also mixes in the time once it's been set via ntpdate
or whatever, it won't help the entropy pool.

						- Ted

