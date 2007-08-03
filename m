Return-Path: <linux-kernel-owner+w=401wt.eu-S1764017AbXHCWiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764017AbXHCWiT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 18:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759208AbXHCWiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 18:38:05 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:34273 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbXHCWiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 18:38:02 -0400
Subject: Re: [PATCH RFC -rt] Allow rcutorture to handle synchronize_sched()
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, dipankar@in.ibm.com, ego@in.ibm.com, vatsa@in.ibm.com
In-Reply-To: <20070803184449.GA2196@linux.vnet.ibm.com>
References: <20070803184449.GA2196@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 03 Aug 2007 15:38:32 -0700
Message-Id: <1186180712.2677.16.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 11:44 -0700, Paul E. McKenney wrote:
> The rcutorture module uses a random-number generator that periodically
> calls get_random_bytes() to add entropy.  This random-number generator
> is invoked from within the RCU read-side critical section, which, in the
> case of the synchronize_sched() variant of RCU, has preeemption disabled.
> Unfortunately, get_random_bytes() ends up acquiring normal spinlocks,
> which can block in -rt, resulting in very large numbers of "scheduling
> while atomic" messages.
> 
> This patch takes a very crude approach, simply substituting the time
> of day for get_random_bytes().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Josh Triplett <josh@kernel.org>


