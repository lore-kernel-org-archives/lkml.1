Return-Path: <linux-kernel-owner+w=401wt.eu-S1754125AbZFZHBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754125AbZFZHBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750887AbZFZHBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:01:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747AbZFZHBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:01:24 -0400
Subject: Re: register_timer_hook use in arch/sh/oprofile
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090624132447.GD6224@elte.hu>
References: <20090624131104.705c828d@skybase>
	 <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase>
	 <20090624123416.GB9510@linux-sh.org> <20090624124542.GB32306@elte.hu>
	 <20090624131440.GA9700@linux-sh.org>  <20090624132447.GD6224@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Jun 2009 09:01:25 +0200
Message-Id: <1245999685.31755.157.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 15:24 +0200, Ingo Molnar wrote:
> 
> [ And long-term analysis ('perf stat' type of runs) dont need IRQs 
>   anyway - perfcounters reads outs the counts and summarizes them 
>   across the measured workload. ]

If the counter width is less than 64 bits we do need to have some
interrupt to read them from before they cycle so we can accumulate the
deltas into a proper u64.

But for proper 64 bit hardware counters there is indeed no need for
that.
