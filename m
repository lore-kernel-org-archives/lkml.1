Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbZAFC0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbZAFC0V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:26:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751611AbZAFC0N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:26:13 -0500
Received: from bee.hiwaay.net ([216.180.54.11]:31554 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921AbZAFC0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:26:12 -0500
Date: Mon, 5 Jan 2009 20:25:51 -0600
From: Chris Adams <cmadams@hiwaay.net>
To: john stultz-lkml <johnstul.lkml@gmail.com>
Cc: Linas Vepstas <linasvepstas@gmail.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Message-ID: <20090106022551.GB1099402@hiwaay.net>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090103002114.GA1538533@hiwaay.net> <1f1b08da0901051821q31a5c98akc5165aac36c6201e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f1b08da0901051821q31a5c98akc5165aac36c6201e@mail.gmail.com>
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Once upon a time, john stultz-lkml <johnstul.lkml@gmail.com> said:
> Grrrr. This has bit us a few times since the "no printk while holding
> the xtime lock" restriction was added.

I didn't see that documented anywhere, so my patch adds a comment to
that effect.

> Thomas: Do you think this warrents adding a check to the printk path
> to make sure the xtime lock isn't held? This way we can at least get a
> warning when someone accidentally adds a printk or calls a function
> that does while holding the xtime_lock.

I'm no kernel locking or scheduling (or anything else) expert, but if
printk can check to see if xtime_lock is held, can it skip trying to
wake klogd (so messages still get logged, just maybe not quite as fast)?
Is there anything else that will wake klogd later?

-- 
Chris Adams <cmadams@hiwaay.net>
Systems and Network Administrator - HiWAAY Internet Services
I don't speak for anybody but myself - that's enough trouble.
