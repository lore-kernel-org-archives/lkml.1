Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYH0Hr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYH0Hr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 03:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYH0HrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 03:47:20 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31791 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbYH0HrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 03:47:20 -0400
X-SourceIP: 80.57.229.25
Subject: Re: [PATCH] x86: printk_time to use tsc before cpu_clock is ready
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080827074230.GA20993@elte.hu>
References: <1219822736-18628-1-git-send-email-yhlu.kernel@gmail.com>
	 <1219822736-18628-2-git-send-email-yhlu.kernel@gmail.com>
	 <20080827074230.GA20993@elte.hu>
Content-Type: text/plain
Date: Wed, 27 Aug 2008 09:47:13 +0200
Message-Id: <1219823233.6462.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-27 at 09:42 +0200, Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > +static unsigned long long tsc_clock(int cpu)
> > +{
> > +	unsigned long long t;
> > +
> > +	rdtscll(t);
> > +
> > +	return t;
> > +}
> 
> hm, i'm not sure i like the whole direction - this reintroduces 
> printk_clock in essence.
> 
> how about initializing cpu_clock() sooner, so that printk timestamps 
> start ticking as soon as possible?

which will make some archs quite unhappy iirc, see those arm and ia64
bugs I caused the other day.

