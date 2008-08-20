Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYHTGXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYHTGXY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 02:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYHTGXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 02:23:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58372 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbYHTGXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 02:23:14 -0400
Date: Tue, 19 Aug 2008 23:21:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <cborntra@de.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 1/3] Add a trigger API for efficient non-blocking
 waiting
Message-Id: <20080819232108.c03660fa.akpm@linux-foundation.org>
In-Reply-To: <48A70185.2020600@goop.org>
References: <48A70185.2020600@goop.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Aug 2008 09:34:13 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> There are various places in the kernel which wish to wait for a
> condition to come true while in a non-blocking context.  Existing
> examples of this are stop_machine() and smp_call_function_mask().
> (No doubt there are other instances of this pattern in the tree.)
> 
> Thus far, the only way to achieve this is by spinning with a
> cpu_relax() loop.  This is fine if the condition becomes true very
> quickly, but it is not ideal:
> 
>  - There's little opportunity to put the CPUs into a low-power state.
>    cpu_relax() may do this to some extent, but if the wait is
>    relatively long, then we can probably do better.

If this change saves a significant amount of power then we should fix
the offending callsites.

>  - In a virtual environment, spinning virtual CPUs just waste CPU
>    resources, and may steal CPU time from vCPUs which need it to make
>    progress.  The trigger API allows the vCPUs to give up their CPU
>    entirely.  The s390 people observed a problem with stop_machine
>    taking a very long time (seconds) when there are more vcpus than
>    available cpus.

If this change saves a significant amount of virtual-cpu-time then we
should fix the offending callsites.


Tell me I'm wrong...
