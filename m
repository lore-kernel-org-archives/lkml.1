Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZAEJLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZAEJLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 04:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZAEJK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 04:10:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40181 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbZAEJK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 04:10:58 -0500
Date: Mon, 5 Jan 2009 10:10:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org, snakebyte@gmx.de,
       akpm@linux-foundation.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       manfred@colorfullife.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH] Fix rcutree grace-period-latency bug on small systems
Message-ID: <20090105091034.GA5440@elte.hu>
References: <20090105043006.GA22049@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090105043006.GA22049@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Kudos to Andi Kleen for finding a grace-period-latency problem!  The
> problem was that the special-case code for small machines never updated
> the ->signaled field to indicate that grace-period initialization had
> completed, which prevented force_quiescent_state() from ever expediting
> grace periods.  This problem resulted in grace periods extending for more
> than 20 seconds.  Not subtle.  I introduced this bug during my inspection
> process when I fixed a race between grace-period initialization and
> force_quiescent_state() execution.
> 
> The following patch properly updates the ->signaled field for the
> "small"-system case (no more than 32 CPUs for 32-bit kernels and no more
> than 64 CPUs for 64-bit kernels).
> 
> I believe that this patch should be included for 2.6.29.
> 
> Located-by: Andi Kleen <andi@firstfloor.org>
> Tested-by: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  rcutree.c |    1 +
>  1 file changed, 1 insertion(+)

Applied to tip/core/urgent, thanks guys!

	Ingo
