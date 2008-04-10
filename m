Return-Path: <linux-kernel-owner+w=401wt.eu-S1756152AbYDJIJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152AbYDJIJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 04:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754484AbYDJIJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 04:09:03 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:19494 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYDJIJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 04:09:01 -0400
Date: Thu, 10 Apr 2008 10:08:58 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: local_softirq_pending()
Message-ID: <20080410080858.GA12073@osiris.boeblingen.de.ibm.com>
References: <20080409192708.7bdbbe9a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409192708.7bdbbe9a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 07:27:08PM -0700, Andrew Morton wrote:
> kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
> kernel/time/tick-sched.c:229: warning: format '%02x' expects type 'unsigned int', but argument 2 has type '__u64'
> 
> I don't think the architecture's local_softirq_pending() should return u64.
> This is the sort of thing which should be consistent across architectures.
> 
> Problem is, we've made such a complete mess of everything that this is a
> bitch to fix.
> 
> The obvious and moderately clean fix is:

I think I will just change the type of softirq_pending in s390's struct lowcore
from __u64 to __u32. That should be the least intrusive "fix" for this problem.
