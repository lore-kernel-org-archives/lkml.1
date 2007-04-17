Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXDQOFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXDQOFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964862AbXDQOFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:05:12 -0400
Received: from omta01ps.mx.bigpond.com ([144.140.82.153]:39049 "EHLO
	omta01ps.mx.bigpond.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964810AbXDQOFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:05:10 -0400
Message-ID: <4624D40E.10500@bigpond.net.au>
Date: Wed, 18 Apr 2007 00:05:02 +1000
From: Peter Williams <pwil3058@bigpond.net.au>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: William Lee Irwin III <wli@holomorphy.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [patch] CFS (Completely Fair Scheduler), v2
References: <20070416220715.GA4071@elte.hu> <46246D61.8010300@bigpond.net.au> <20070417075146.GM2986@holomorphy.com> <20070417081606.GB5076@elte.hu>
In-Reply-To: <20070417081606.GB5076@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at oaamta01ps.mx.bigpond.com from [58.164.138.40] using ID pwil3058@bigpond.net.au at Tue, 17 Apr 2007 14:05:07 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * William Lee Irwin III <wli@holomorphy.com> wrote:
> 
>> On Tue, Apr 17, 2007 at 04:46:57PM +1000, Peter Williams wrote:
>>
>>> Have you considered using rq->raw_weighted_load instead of 
>>> rq->nr_running in calculating fair_clock?  This would take the nice 
>>> value (or RT priority) of the other tasks into account when 
>>> determining what's fair.
>> I suspect you mean 
>> (curr->load_weight*delta_exec)/rq->raw_weighted_load in update_curr().
> 
> good idea, i'll try that.

In the longer term, I'd suggest modifying this idea to use the maximum 
of rq->raw_weighted_load and a running average of rq->raw_weighted_load 
much the same as was done within the load balancer code.  This will tend 
to make scheduling "smoother".  To try the idea out you could (on an SMP 
system) use one of the rq->cpu_load[] metrics as the running average.

Peter
-- 
Peter Williams                                   pwil3058@bigpond.net.au

"Learning, n. The kind of ignorance distinguishing the studious."
  -- Ambrose Bierce
