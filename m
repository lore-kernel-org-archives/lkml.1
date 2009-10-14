Return-Path: <linux-kernel-owner+w=401wt.eu-S1758598AbZJNKzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598AbZJNKzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 06:55:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758535AbZJNKzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 06:55:09 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:49747 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbZJNKzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 06:55:08 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] perf_event: Adjust frequency and unthrottle for
 non-group-leader events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Mark W. Krentel" <krentel@cs.rice.edu>,
       linux-kernel@vger.kernel.org,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>
In-Reply-To: <19157.26731.855609.165622@cargo.ozlabs.ibm.com>
References: <19157.26731.855609.165622@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Wed, 14 Oct 2009 12:54:12 +0200
Message-Id: <1255517652.8392.378.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-14 at 16:58 +1100, Paul Mackerras wrote:
> The loop in perf_ctx_adjust_freq checks the frequency of sampling
> event counters, and adjusts the event interval and unthrottles the
> event if required, and resets the interrupt count for the event.
> However, at present it only looks at group leaders.
> 
> This means that a sampling event that is not a group leader will
> eventually get throttled, once its interrupt count reaches
> sysctl_perf_event_sample_rate/HZ --- and that is guaranteed to
> happen, if the event is active for long enough, since the interrupt
> count never gets reset.  Once it is throttled it never gets
> unthrottled, so it basically just stops working at that point.
> 
> This fixes it by making perf_ctx_adjust_freq use ctx->event_list
> rather than ctx->group_list.  The existing spin_lock/spin_unlock
> around the loop makes it unnecessary to put rcu_read_lock/
> rcu_read_unlock around the list_for_each_entry_rcu().
> 
> Reported-by: Mark W. Krentel <krentel@cs.rice.edu>
> Signed-off-by: Paul Mackerras <paulus@samba.org>

Looks good, thanks Paul!

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
> Apparently this bug was only seen on powerpc, and not on x86.  I have
> no idea why.

Weird, should work the same way on both of them.


