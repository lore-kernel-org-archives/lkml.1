Return-Path: <linux-kernel-owner+w=401wt.eu-S1031134AbXDSFRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031134AbXDSFRR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 01:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031154AbXDSFRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 01:17:17 -0400
Received: from smtp1.osdl.org ([65.172.181.25]:57223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031134AbXDSFRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 01:17:16 -0400
Date: Wed, 18 Apr 2007 22:14:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
Message-Id: <20070418221432.e4dbcf4f.akpm@linux-foundation.org>
In-Reply-To: <20070419031807.GA24512@wotan.suse.de>
References: <20070417060955.GO8915@holomorphy.com>
	<20070417061503.GC1057@wotan.suse.de>
	<20070417062621.GL2986@holomorphy.com>
	<20070417070155.GF1057@wotan.suse.de>
	<20070417213954.GE11166@waste.org>
	<20070418031511.GA18452@wotan.suse.de>
	<20070418043831.GR11115@waste.org>
	<20070418050024.GF18452@wotan.suse.de>
	<20070418055525.GS11115@waste.org>
	<alpine.LFD.0.98.0704180742470.2828@woody.linux-foundation.org>
	<20070419031807.GA24512@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 05:18:07 +0200 Nick Piggin <npiggin@suse.de> wrote:

> And yes, by fairly, I mean fairly among all threads as a base resource
> class, because that's what Linux has always done

Yes, there are potential compatibility problems.  Example: a machine with
100 busy httpd processes and suddenly a big gzip starts up from console or
cron.

Under current kernels, that gzip will take ages and the httpds will take a
1% slowdown, which may well be exactly the behaviour which is desired.

If we were to schedule by UID then the gzip suddenly gets 50% of the CPU
and those httpd's all take a 50% hit, which could be quite serious.

That's simple to fix via nicing, but people have to know to do that, and
there will be a transition period where some disruption is possible.

