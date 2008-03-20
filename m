Return-Path: <linux-kernel-owner+w=401wt.eu-S1758656AbYCTXsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656AbYCTXsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYCTXsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:48:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbYCTXsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:48:16 -0400
Date: Thu, 20 Mar 2008 16:47:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: David Brownell <david-b@pacbell.net>, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
Message-Id: <20080320164741.734e838c.akpm@linux-foundation.org>
In-Reply-To: <20080320225612.GB20788@khazad-dum.debian.net>
References: <20080316184349.GA28543@khazad-dum.debian.net>
	<200803161246.23909.david-b@pacbell.net>
	<20080318001429.896acf51.akpm@linux-foundation.org>
	<20080320225612.GB20788@khazad-dum.debian.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2008 19:56:12 -0300 Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> Can we add "in_scheduleable()", or maybe "can_schedule()", that returns
> in_atomic() if CONFIG_PREEMT, or 0 if there is no way to know?   To my
> limited knowledge of how that part of the kernel works, it would do the
> right thing.

If we did that, then people would use it.  And that would be bad.  It'll
lead to code which behaves differently on non-preemptible kernels, to code
which works less well on non-preemptible kernels and it will lead to less
well-thought-out code in general.

Really, this all points at an ill-designed part of the leds interface.  The
consistent pattern we use in the kernel is that callers keep track of
whether they are running in a schedulable context and, if necessary, they
will inform callees about that.  Callees don't work it out for themselves.

