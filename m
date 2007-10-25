Return-Path: <linux-kernel-owner+w=401wt.eu-S1762990AbXJYUVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762990AbXJYUVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 16:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756408AbXJYUVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 16:21:39 -0400
Received: from waste.org ([66.93.16.53]:36315 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759051AbXJYUVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 16:21:38 -0400
Date: Thu, 25 Oct 2007 15:19:48 -0500
From: Matt Mackall <mpm@selenic.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: IRQ off latency of printk is very high
Message-ID: <20071025201948.GO17536@waste.org>
References: <4720F21F.9090404@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4720F21F.9090404@am.sony.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2007 at 12:44:31PM -0700, Tim Bird wrote:
> I've been looking at 'IRQ off' latency in the Linux kernel, on
> version 2.6.22 for target using an ARM processor.
> I use a serial console, at 115200 bps.

Printk to the serial console uses polled I/O to get deterministic,
reliable, and -timely- output. If our very next statement (or interrupt)
may lock up the box, we want to be sure our printk has actually been
delivered before that happens.

Kindof a bummer for realtime, but also rather hard to get around.

> I've noticed that calls to printk disable interrupts for
> excessively long times.  I have a long test printk of
> over 200 chars, that holds interrupts off for 24 milliseconds.

2000bits @ 115200bps -> 17.4ms

> Are these are really needed, with all this other locking
> going on?  Any ideas for fixing this?

Well, we could have a commandline option that made messages with a
priority below X go out buffered. But it'd be a lousy default from a
debugging perspective.

-- 
Mathematics is the supreme nostalgia of our time.
