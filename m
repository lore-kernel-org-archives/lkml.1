Return-Path: <linux-kernel-owner+w=401wt.eu-S1751404AbXB1Dvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751404AbXB1Dvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 22:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXB1Dvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 22:51:44 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60852 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXB1Dvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 22:51:43 -0500
Date: Wed, 28 Feb 2007 09:21:49 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: Problem with freezable workqueues
Message-ID: <20070228035149.GL29179@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <200702272251.28844.rjw@sisk.pl> <20070228030113.GJ29179@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070228030113.GJ29179@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 28, 2007 at 08:31:13AM +0530, Srivatsa Vaddagiri wrote:
> This problem (of kthread_stopping a frozen thread) was there when we
> implemented freezer-based cpu hotplug. We worked around that in the
> callbacks by thawing the worker thread first before kthread_stopping it,
> which is working pretty neatly.
> 
> Should that fix the issue? 

In addition to thawing worker thread before kthread_stopping it, there
are minor changes required in worker threads, to check for
is_cpu_offline(bind_cpu) when they come out of refrigerator and jump to
wait_to_die if so (ex: softirq.c).

I guess you would need these changes before freezer-based hotplug is
merged, in which case Gautham can send those patches out first.

-- 
Regards,
vatsa
