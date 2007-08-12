Return-Path: <linux-kernel-owner+w=401wt.eu-S934719AbXHLLt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934719AbXHLLt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 07:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934459AbXHLLtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 07:49:42 -0400
Received: from 1wt.eu ([62.212.114.60]:1666 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934398AbXHLLte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 07:49:34 -0400
Date: Sun, 12 Aug 2007 13:47:26 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jason Uhlenkott <jasonuhl@jasonuhl.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Vincent Fortier <Vincent.Fortier1@EC.GC.CA>,
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [2.6.20.16 review 27/28] NTP: remove clock_was_set() call to prevent deadlock
Message-ID: <20070812114726.GB29161@1wt.eu>
References: <20070811184752.%N@1wt.eu> <20070811184857.%N@1wt.eu> <20070812111558.GA18647@aurum.uhlenkott.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812111558.GA18647@aurum.uhlenkott.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 12, 2007 at 04:15:58AM -0700, Jason Uhlenkott wrote:
> On Sat, Aug 11, 2007 at 21:48:19 +0200, Willy Tarreau wrote:
> > The clock_was_set() call in seconds_overflow() which happens only when
> > leap seconds are inserted / deleted is wrong in two aspects:
> > 
> > 1. it results in a call to on_each_cpu() with interrupts disabled
> > 2. it is potential deadlock source vs. call_lock in smp_call_function()
> 
> clock_was_set() is a no-op in 2.6.20, so this one looks unnecessary
> (but harmless).  Thankfully the "hang every Linux box on the planet
> simultaneously" regression (okay, that's *slight* hyperbole) was
> limited to 2.6.21.

OK, patch removed.

Thanks for your help,
Willy

