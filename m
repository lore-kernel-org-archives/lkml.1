Return-Path: <linux-kernel-owner+w=401wt.eu-S1161979AbXECOXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161979AbXECOXX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 10:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161994AbXECOXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 10:23:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:43766 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161979AbXECOXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 10:23:22 -0400
Date: Thu, 3 May 2007 19:56:18 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ting Yang <tingy@cs.umass.edu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] CFS scheduler, -v8
Message-ID: <20070503142618.GB25479@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070501212223.GA29867@elte.hu> <4637FE0A.7090405@cs.umass.edu> <20070503085015.GA20516@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503085015.GA20516@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 10:50:15AM +0200, Ingo Molnar wrote:
> - EEVDF concentrates on real-time (SCHED_RR-alike) workloads where they
>   know the length of work units

This is what I was thinking when I wrote earlier that EEVDF expects each
task will specify "length of each new request"
(http://lkml.org/lkml/2007/5/2/339).

The other observation that I have of EEVDF is that it tries to be fair
in the virtual time scale (each client will get 'wi' real units in 1
virtual unit), whereas sometimes fairness in real-time scale also matters?
For ex: a multi-media app would call scheduler fair to it, it it recvs
atleast 1 ms cpu time every 10 *real* milleseconds (frame-time). A rogue
user (or workload) that does a fork bomb may skew this fairness for that
multi-media app in real-time scale under EEVDF?

-- 
Regards,
vatsa
