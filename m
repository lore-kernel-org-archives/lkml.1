Return-Path: <linux-kernel-owner+w=401wt.eu-S1754126AbZBRFbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbZBRFbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 00:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZBRFbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 00:31:14 -0500
Received: from ozlabs.org ([203.10.76.45]:59140 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbZBRFbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 00:31:13 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
Date: Wed, 18 Feb 2009 16:01:06 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
References: <20090217215904.059250145@chello.nl> <20090217220053.500765201@chello.nl>
In-Reply-To: <20090217220053.500765201@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181601.06738.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009 08:29:06 Peter Zijlstra wrote:
> Remove the use of kmalloc() from the smp_call_function_*() calls.

This patch is actually quite nice.  Not sure it's correct, but it's neat :)

One minor quibble:

> +			data = &per_cpu(csd_data, me);

"data = &__get_cpu_var(csd_data);" is slightly preferred.  A few less cycles.

Thanks,
Rusty.
