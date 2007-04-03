Return-Path: <linux-kernel-owner+w=401wt.eu-S1422682AbXDCUGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422682AbXDCUGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422684AbXDCUGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:06:23 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:40060 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422682AbXDCUGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:06:22 -0400
Date: Tue, 3 Apr 2007 19:45:16 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org, paulmck@us.ibm.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       dipankar@in.ibm.com, dino@in.ibm.com, masami.hiramatsu.pt@hitachi.com
Subject: Re: [RFC] Cpu-hotplug: Using the Process Freezer (try2)
Message-ID: <20070403141516.GB14900@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070402053457.GA9076@in.ibm.com> <20070402061612.GA7072@elte.hu> <20070402092818.GE2456@in.ibm.com> <20070402111828.GA14771@elte.hu> <20070402124200.GA9566@in.ibm.com> <20070402185607.GA2081@elte.hu> <20070403125619.GA32444@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070403125619.GA32444@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2007 at 06:26:19PM +0530, Srivatsa Vaddagiri wrote:
> 
> Besides, how problematic is this in practise (that threads sleep for
> extended durations in TASK_INTERRUPTIBLE state breaking
> freezer/suspend/hotplug)?
> 
> Should we ignore this for the timebeing and take up later as and when
> users report problems?

In my case, the problem of freezer failing was due to the vfork freezer race
in do_fork. The parent task was waiting_for_completion() while the child was
frozen.

Rafael has already sent out the fix for that, but for some reason I
don't see it in the -mm.

With that fix, freezer and hence hotplug succeeds even when I am running
a 'make -j' test.

> 
> -- 
> Regards,
> vatsa

Thanks and Regards
gautham.

-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
