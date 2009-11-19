Return-Path: <linux-kernel-owner+w=401wt.eu-S1757245AbZKSKHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245AbZKSKHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 05:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755291AbZKSKHy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 05:07:54 -0500
Received: from www.tglx.de ([62.245.132.106]:40062 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754225AbZKSKHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 05:07:54 -0500
Date: Thu, 19 Nov 2009 11:05:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, heiko.carstens@de.ibm.com,
       feng.tang@intel.com, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] hrtimer: Fix /proc/timer_list regression
In-Reply-To: <20091119072040.GA23579@elte.hu>
Message-ID: <alpine.LFD.2.00.0911191053390.24119@localhost.localdomain>
References: <alpine.LFD.2.00.0911181933540.24119@localhost.localdomain> <tip-887a29f59b93cf54e21814869a4ab6e80b6fa623@git.kernel.org> <20091119072040.GA23579@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Nov 2009, Ingo Molnar wrote:
> i've bisected back to it:
> 
> | 887a29f59b93cf54e21814869a4ab6e80b6fa623 is the first bad commit
> | commit 887a29f59b93cf54e21814869a4ab6e80b6fa623
> | Author: Feng Tang <feng.tang@intel.com>
> | Date:   Thu Sep 3 16:32:53 2009 +0800
> |
> |    hrtimer: Fix /proc/timer_list regression
> 
> Config attached.
> 
> I've removed it from timers/urgent for now.

Come on, this is a patently wrong conclusion.

We call timer_stats_update_stats() which returns on top of the
function due to:

	if (likely(!timer_stats_active))
		return;

timer_stats_active is 0 during boot and you can only activate it by
writing to /proc/timer_stats which you certainly did not at this
point.

Can you please explain how a call to a function which returns right
away can cause that problem ? 

That patch unearthed some other bug and your revert is just papering
over that fact.

Thanks,

	tglx
