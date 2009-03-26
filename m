Return-Path: <linux-kernel-owner+w=401wt.eu-S1754230AbZCZHvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230AbZCZHvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 03:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbZCZHv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 03:51:29 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:34514 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbZCZHv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 03:51:28 -0400
Date: Thu, 26 Mar 2009 13:21:01 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Piet Delaney <piet.delaney@tensilica.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, Johannes Weiner <jw@emlix.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH} - There appears  to be a minor race condition in
	sched.c
Message-ID: <20090326075101.GE24227@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <49CAFA83.1000005@tensilica.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <49CAFA83.1000005@tensilica.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Piet Delaney <piet.delaney@tensilica.com> [2009-03-25 20:46:11]:

> Ingo, Peter:
>
> There appears to be a minor race condition in sched.c where
> you can get a division by zero. I suspect that it only shows
> up when the kernel is compiled without optimization and the code
> loads rq->nr_running from memory twice.
>
> It's part of our SMP stabilization changes that I just posted to:
>
>     git://git.kernel.org/pub/scm/linux/kernel/git/piet/xtensa-2.6.27-smp.git
>
> I mentioned it to Johannes the other day and he suggested passing it on to you ASAP.
>

The latest version uses ACCESS_ONCE to get rq->nr_running and then
uses that value. I am not sure what version you are talking about, if
it is older, you should consider backporting from the current version.


-- 
	Balbir
