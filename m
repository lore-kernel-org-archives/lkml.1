Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbYHRKt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbYHRKt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 06:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYHRKtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 06:49:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51774 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYHRKtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 06:49:51 -0400
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
From: Peter Zijlstra <peterz@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <200808172304.50103.nickpiggin@yahoo.com.au>
References: <1218880552.11912.9.camel@matrix>
	 <1218898413.10800.252.camel@twins>
	 <200808172304.50103.nickpiggin@yahoo.com.au>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 12:50:01 +0200
Message-Id: <1219056601.10800.306.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-17 at 23:04 +1000, Nick Piggin wrote:
> On Sunday 17 August 2008 00:53, Peter Zijlstra wrote:

> > Has nothing to do with CFS, but everything to do with the fact that we
> > now have a 95% bandwidth control by default.
> >
> > Does doing:
> >
> > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> >
> > fix it?
> >
> > So, up to 95% cpu usage (per sched_rt_period_us) FIFO and RR behave like
> > they always did, once they cross that line, they'll be throttled.
> >
> > 95% seemed like a sane default in that it leaves a little room to
> > recover from a run-away rt process (esp handy now that !root users can
> > also use RT scheduling classes), and should be enough for most
> > applications as they usually don't consume all that much time.
> 
> Did it seem sane to break POSIX and backwards compatiblity by default?

Up to a point, yes.

There were quite a few complaints that runaway RT tasks could render a
machine unusable - which made 'desktop' usage of the RT class unsafe.

This 95%/1s default allows most RT tasks to run without having to tinker
with the settings, and for those who do need something else, they can
get it too, but will have to turn a knob.

But I guess we could change the default back to unlimited and default to
unsafe if people feel strongly about this.


