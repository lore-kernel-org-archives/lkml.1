Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZCTOu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZCTOu6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbZCTOut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:50:49 -0400
Received: from viefep19-int.chello.at ([62.179.121.39]:54412 "EHLO
	viefep19-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbZCTOus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:50:48 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH/RFC] perfcounters: record time running and time enabled
 for each counter
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
References: <18883.34555.748843.35920@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Fri, 20 Mar 2009 15:50:31 +0100
Message-Id: <1237560631.24626.103.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 23:07 +1100, Paul Mackerras wrote:
> Impact: new functionality
> 
> Currently, if there are more counters enabled than can fit on the CPU,
> the kernel will multiplex the counters on to the hardware using
> round-robin scheduling.  That isn't too bad for sampling counters, but
> for counting counters it means that the value read from a counter
> represents some unknown fraction of the true count of events that
> occurred while the counter was enabled.
> 
> This remedies the situation by keeping track of how long each counter
> is enabled for, and how long it is actually on the cpu and counting
> events.  These times are recorded in nanoseconds using the task clock
> for per-task counters and the cpu clock for per-cpu counters.

Can't we do this by simply adding some software counters? A task local
to each group and a task local on its own.

Since the solo task local will always be scheduled, you can get the
sampling fraction by comparing the group task local one to the solo one.



