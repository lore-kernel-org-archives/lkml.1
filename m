Return-Path: <linux-kernel-owner+w=401wt.eu-S1760905AbZCSWRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760905AbZCSWRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 18:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758433AbZCSWRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 18:17:31 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:43459 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbZCSWRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 18:17:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18882.50291.118201.148297@cargo.ozlabs.ibm.com>
Date: Fri, 20 Mar 2009 09:17:23 +1100
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] perf_counter: powerpc: clean up perc_counter_interrupt
In-Reply-To: <20090319194234.024464535@chello.nl>
References: <20090319192610.660857280@chello.nl>
	<20090319194234.024464535@chello.nl>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra writes:

> From: Paul Mackerras <paulus@samba.org>
> 
> > Nice cleanup, and thanks for updating powerpc too.  With this, I think
> > we'll need to update the powerpc perf_counter_interrupt a bit: we
> > might as well use get_perf_counter_pending() instead of the wakeup
> > variable now.  I'll send an extra patch once I have done some testing.
> 
> This seems to work OK.
> 
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Let's have a better patch description (my fault for not providing a
decent one in the first place):

perf_counter: powerpc: clean up perf_counter_interrupt

From: Paul Mackerras <paulus@samba.org>

This updates the powerpc perf_counter_interrupt following on from the
"perf_counter: unify irq output code" patch.  Since we now use the
generic perf_counter_output code, which sets the perf_counter_pending
flag directly, we no longer need the need_wakeup variable.  This
removes need_wakeup and makes perf_counter_interrupt use
get_perf_counter_pending() instead.

Signed-off-by: Paul Mackerras <paulus@samba.org>
