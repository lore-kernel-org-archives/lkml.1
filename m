Return-Path: <linux-kernel-owner+w=401wt.eu-S1752933AbZHZTFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbZHZTFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZHZTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:05:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41776 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbZHZTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:05:53 -0400
Subject: Re: [RFC][PATCH -rt] sched: fully ignore RT tasks for CFS
 load-balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <4A958480.3070207@us.ibm.com>
References: <1251297875.18584.5.camel@twins>  <4A958480.3070207@us.ibm.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Aug 2009 21:04:45 +0200
Message-Id: <1251313485.18584.33.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-08-26 at 11:52 -0700, Darren Hart wrote:
> Peter Zijlstra wrote:
> > Since -rt runs IRQs and SoftIRQs as RT tasks and load-balancing is done
> > from softirq context, there is always at least one RT task (and very
> > likely multiple) running when we balance.
> > 
> > The current (and totally broken) interaction between RT tasks and CFS
> > load-balancing makes it so that we'll try to evacuate a significant
> > amount of tasks due to RT tasks being runnable.
> > 
> > Solve this in another broken way by not accounting RT tasks at all.
> > 
> > This will likely break another class of cases, but until we can properly
> > fix this, we might as well do this.
> 
> Peter,
> 
> Do we know why this became a problem lately?  I don't recall seeing load 
> balancing issues like this way back around 2.6.21 or 22 when CFS was 
> released.  Is the cpu_load stuff fairly recent?

The earlier problem solved by the previous patch was caused by tglx
tinkering with the cpu_load computation.

This particular problem I'm not sure about, afaict it should have been
present a long long time.
