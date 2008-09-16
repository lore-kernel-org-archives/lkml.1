Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbYIPEtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbYIPEtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 00:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYIPEtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 00:49:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60135 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYIPEtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 00:49:06 -0400
Subject: Re: max_clock of the patch "sched_clock: fix cpu_clock()"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1221534097.30750.20.camel@minggr>
References: <1221534097.30750.20.camel@minggr>
Content-Type: text/plain
Date: Tue, 16 Sep 2008 06:48:30 +0200
Message-Id: <1221540510.6943.1.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-16 at 11:01 +0800, Lin Ming wrote:
> Hi, Peter,
> 
> I have a question of the max_clock in below patch,
> commit 354879bb977e06695993435745f06a0f6d39ce2b
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Aug 25 17:15:34 2008 +0200
> 
>     sched_clock: fix cpu_clock()
> 
> The original code to calculate min_clock and max_clock is,
> min_clock = scd->tick_gtod + delta_jiffies * TICK_NSEC;
> max_clock = min_clock + TICK_NSEC;
> 
> Now it's changed to,
> min_clock = wrap_max(scd->tick_gtod, scd->clock);
> max_clock = scd->tick_gtod + TICK_NSEC;
> 
> Is this max_clock still correct if, in a rare case, irq is disabled for
> many ticks?

Nope, it wont (nor would the old), but having irqs disabled for that
long would be something worth fixing.

