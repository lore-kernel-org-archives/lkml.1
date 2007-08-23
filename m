Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbXHWRsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbXHWRsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 13:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758812AbXHWRsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 13:48:35 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:31410 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757434AbXHWRse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 13:48:34 -0400
Subject: Re: [patch] sched: fix broken smt/mc optimizations with CFS
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>, nickpiggin@yahoo.com.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070823121341.GA5775@elte.hu>
References: <20070816010150.GG10033@linux-os.sc.intel.com>
	 <20070823115416.GA31027@elte.hu>  <20070823121341.GA5775@elte.hu>
Content-Type: text/plain
Date: Thu, 23 Aug 2007 10:42:46 -0700
Message-Id: <1187890966.2435.81.camel@dhcp193.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-23 at 14:13 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > [...] So how about the patch below instead?
> 
> the right patch attached.
> 
> -------------------------------->
> Subject: sched: fix broken SMT/MC optimizations
> From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
> 
> On a four package system with HT - HT load balancing optimizations were
> broken.  For example, if two tasks end up running on two logical threads
> of one of the packages, scheduler is not able to pull one of the tasks
> to a completely idle package.
> 
> In this scenario, for nice-0 tasks, imbalance calculated by scheduler
> will be 512 and find_busiest_queue() will return 0 (as each cpu's load
> is 1024 > imbalance and has only one task running).

Is there an upper bound on the number of tasks that can migrate during a
new idle balance? The reason that I'm asking is because I've been seeing
some large latency in the new idle path into load_balance().. I'm not
sure if lots of tasks are getting migrated or if it's just the iteration
over tasks in the rb-tree ..

Daniel

