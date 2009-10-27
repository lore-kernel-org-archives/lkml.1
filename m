Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbZJ0MzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbZJ0MzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 08:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbZJ0MzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 08:55:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:58734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbZJ0Myi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 08:54:38 -0400
Message-ID: <4AE6EDBF.7040905@kernel.org>
Date: Tue, 27 Oct 2009 13:55:27 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
       linux-ia64@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu: allow pcpu_alloc() to be called with IRQs
 off
References: <alpine.LSU.2.00.0910271328340.19847@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910271328340.19847@wotan.suse.de>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> pcpu_alloc() and pcpu_extend_area_map() perform a series of
> spin_lock_irq()/spin_unlock_irq() calls, which make them unsafe
> with respect to being called from contexts which have IRQs off.
> 
> This patch converts the code to perform save/restore of flags instead,
> making pcpu_alloc() (or __alloc_percpu() respectively) to be called
> from early kernel startup stage, where IRQs are off.
> 
> This is needed for proper initialization of per-cpu rq_weight data from
> sched_init().
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

I'll wait for response on the series and push it through percpu#fixes
tomorrow if there's no objection.

Thanks.

-- 
tejun
