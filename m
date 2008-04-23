Return-Path: <linux-kernel-owner+w=401wt.eu-S1761485AbYDWGHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761485AbYDWGHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 02:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbYDWGHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 02:07:30 -0400
Received: from brick.kernel.dk ([87.55.233.238]:15872 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYDWGH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 02:07:29 -0400
Date: Wed, 23 Apr 2008 08:07:26 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, npiggin@suse.de,
       torvalds@linux-foundation.org, sam@ravnborg.org
Subject: Re: [PATCH 1/11] Add generic helpers for arch IPI function calls
Message-ID: <20080423060725.GT12774@kernel.dk>
References: <1208890227-24808-1-git-send-email-jens.axboe@oracle.com> <1208890227-24808-2-git-send-email-jens.axboe@oracle.com> <1208895423.7115.290.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208895423.7115.290.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22 2008, Peter Zijlstra wrote:
> On Tue, 2008-04-22 at 20:50 +0200, Jens Axboe wrote:
> 
> > +int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
> > +			     int retry, int wait)
> > +{
> > +	unsigned long flags;
> > +	/* prevent preemption and reschedule on another processor */
> > +	int me = get_cpu();
> > +
> > +	/* Can deadlock when called with interrupts disabled */
> > +	WARN_ON(wait && irqs_disabled());
> 
> With this fallback to wait the above condition isn't sufficient.

What deadlock are you concerned with here? Would making cfd_fallback
per-cpu make you feel better?

-- 
Jens Axboe

