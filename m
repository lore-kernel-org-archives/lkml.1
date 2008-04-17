Return-Path: <linux-kernel-owner+w=401wt.eu-S1765811AbYDQKeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765811AbYDQKeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 06:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759085AbYDQKeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 06:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757620AbYDQKeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 06:34:03 -0400
Date: Thu, 17 Apr 2008 03:33:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417033333.947dfcc9.akpm@linux-foundation.org>
In-Reply-To: <84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417090626.GA14383@elte.hu>
	<20080417021813.04df7912.akpm@linux-foundation.org>
	<20080417093025.GA17389@elte.hu>
	<20080417023603.672d1032.akpm@linux-foundation.org>
	<84144f020804170319g6e0b90ffq1c42179e084d18f@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 13:19:32 +0300 "Pekka Enberg" <penberg@cs.helsinki.fi> wrote:

> On Thu, Apr 17, 2008 at 12:36 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > > you mean kmemcheck? Yes, that's planned. We've been working 4 months
> > > non-stop on kmemcheck to make it mergeable and usable, it's at version 7
> > > right now, and it caught a handful of real bugs already (such as
> > > 63a7138671c - unfortunately not credited in the log to kmemcheck). But
> > > because it touches SLUB (because it has to - and they are acked by
> > > Pekka) i never had the chance to move it into the for-akpm branch.
> >
> >  Does it really really really need to consume one of our few remaining page
> >  flags?  We'll be in a mess when we run out.
> 
> FYI, the initial version of kmemcheck didn't have a separate page flag
> (it abused SLUB internals) but it got really hairy and I think I
> finally convinced Vegard to switch over to page flags after some
> hair-pulling when we hit a bug. So yes, from SLUB maintainer point of
> view, we _really, really_ want to use a page flag here.

Thank you whoever wrote kmemcheck.txt

How come slub uses one byte to track the status of each byte when it could
use a single bit?

We (still!) have not made the decision whether to proceed with slab or
slub.  How hard would it be to port kmemcheck into slab?

