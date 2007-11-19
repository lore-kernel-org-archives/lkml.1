Return-Path: <linux-kernel-owner+w=401wt.eu-S1756123AbXKSXG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756123AbXKSXG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 18:06:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXKSXGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 18:06:47 -0500
Received: from ozlabs.org ([203.10.76.45]:38349 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbXKSXGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 18:06:46 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch 5/8] Immediate Values - x86 Optimization (simplified)
Date: Tue, 20 Nov 2007 10:06:34 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@muc.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>
References: <20071113185800.436425570@polymtl.ca> <200711191011.18634.rusty@rustcorp.com.au> <20071119142803.GA19301@Krystal>
In-Reply-To: <20071119142803.GA19301@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711201006.34954.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2007 01:28:03 Mathieu Desnoyers wrote:
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > I think it would be easier to just fast-path the num_online_cpus == 1
> > case, even if you want to keep this "update_early" interface.
>
> Nope, that could lead to problems. I call core_immediate_update()
> _very_ early, before boot_cpu_init() is called.

Ah, I see the problem.  It would in fact be clearer for us to move 
boot_cpu_init() up to just after smp_setup_processor_id() in start_kernel 
anyway, not just for this code, but in general.

> Therefore, 
> cpu_online_map is not set yet. I am not sure the benefit of using
> num_online_cpus outweights the added fragility wrt other boot process
> initializations.

I think it's still a win, though worth a comment that we always go via the 
non-IPI path for the early boot case.

Cheers,
Rusty.
