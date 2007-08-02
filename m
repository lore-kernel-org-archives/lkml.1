Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXHBPEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXHBPEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbXHBPEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:04:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59871 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818AbXHBPEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:04:01 -0400
Date: Thu, 2 Aug 2007 17:03:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Roehricht <ml@felicis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
Message-ID: <20070802150350.GA3030@elte.hu>
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org> <20070802114012.GA4067@elte.hu> <46B1F182.3010608@felicis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B1F182.3010608@felicis.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Martin Roehricht <ml@felicis.org> wrote:

> On 08/02/2007 01:40 PM, Ingo Molnar wrote:
> >in the SMP migration code, the 'old scheduler' indeed picks the lowest 
> >priority one, _except_ if that task is running on another CPU or is too 
> >'cache hot':
> 
> But why is it, that the scheduler picks the lowest priority one? I 
> thought sched_find_first_bit() picks the index of the lowest order bit 
> in the bitmap and thus the highest priority job. Is that wrong? What 
> needs to be changed to let the scheduler pick the highest priority 
> task from a given runqueue? I am very confused ...

it first picks the lowest index (i.e. the highest priority active 
priority-queue), but within those tasks (each task in that priority 
queue has equal priority) the load-balancer has freedom to pick any. 
Based on performance data we went for picking from the tail of the 
queue.

	Ingo
