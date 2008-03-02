Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbYCBVvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbYCBVvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 16:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbYCBVvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 16:51:01 -0500
Received: from ozlabs.org ([203.10.76.45]:52078 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580AbYCBVvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 16:51:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: [PATCH 1/2] kthread: add a missing memory barrier to kthread_stop()
Date: Mon, 3 Mar 2008 08:50:56 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>, Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andy Whitcroft <apw@shadowen.org>
References: <1203543390.6307.24.camel@earth>
In-Reply-To: <1203543390.6307.24.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803030850.57615.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 February 2008 08:36:30 Dmitry Adamushko wrote:
> From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> Subject: kthread: add a missing memory barrier to kthread_stop()
>
> We must ensure that kthread_stop_info.k has been updated before
> kthread's wakeup. This is required to properly support
> the use of kthread_should_stop() in the main loop of kthread.
>
> wake_up_process() doesn't imply a full memory barrier,
> so we add an explicit one.

I always believed that wake_up_process() implies a write barrier.  It's pretty 
common to set something up then wake the intended recipient.

So I think this patch is overkill, but I'm happy to be corrected.

Thanks!
Rusty.
