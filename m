Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYLAKp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYLAKp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 05:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbYLAKpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 05:45:50 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36341 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbYLAKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 05:45:50 -0500
Date: Mon, 1 Dec 2008 10:45:29 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Trilok Soni <soni.trilok@gmail.com>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Re: keypad/touchscreen driver events latencies using LTTng on ARM?
Message-ID: <20081201104529.GB28971@flint.arm.linux.org.uk>
References: <5d5443650811301000t58665a7j7aa93be52325a23b@mail.gmail.com> <20081201103502.GC25340@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081201103502.GC25340@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2008 at 05:35:02AM -0500, Mathieu Desnoyers wrote:
> However, I wonder if some of the newer ARM boards would happen to have a
> cycle counter (timestamp counter), so we could implement a get_cycles()
> and trace clock for them ?

There continues to be nothing architected for that - it would be very
SoC specific and the precision and resolution is very variable if it's
provided at all.  About the best implementation is a 32-bit counter
being clocked at various rates depending on the implementation.

Our best implementation is used for sched_clock() with all the
cnt32_to_63() stuff to extend the size of the counter which as we've
seen from other threads, may cause problems if used for other purposes.

The next best implementation is probably the hrtimer stuff.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
