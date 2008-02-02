Return-Path: <linux-kernel-owner+w=401wt.eu-S1762444AbYBBNvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762444AbYBBNvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 08:51:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757224AbYBBNuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 08:50:54 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51224 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753597AbYBBNux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 08:50:53 -0500
Date: Sat, 2 Feb 2008 14:50:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080202135037.GC925@elte.hu>
References: <20080130131748.GA3796@elf.ucw.cz> <200801311755.33899.david-b@pacbell.net> <20080202124759.GB25773@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080202124759.GB25773@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> > Plus, the way you're doing it now is violating the locking protocol 
> > used by that driver.
> 
> Yep, you are right, but that is the easy issue to fix. There's hard 
> issue: I need
> 
> struct rtc_device *rtc
> 
> for the rtc that can be used for system resume, and I'd like to get it 
> without violating too many layers. How to do that?
> 
> Ideally, I need 
> 
> set_alarm(int)
> 
> ...that will magically pick the right rtc device to talk to, and set 
> alarm on it. I don't see how to implement it with current code.

i'd really love to have a /dev/rtc device compatibility APIs, both 
inside and outside the kernel. I really dont know why the new RTC code 
does not do it - why does it put up artificial anti-adoption barriers to 
make it harder to migrate to the new code?

	Ingo
