Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZKSI6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZKSI6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754074AbZKSI6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:58:34 -0500
Received: from ozlabs.org ([203.10.76.45]:46458 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZKSI6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:58:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] Final cpumask conversion patches for 4096+ cpus
Date: Thu, 19 Nov 2009 19:28:37 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911191928.38048.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally, these 6 patches actually allocate short (nr_cpu_ids-bits) cpumasks
and nail down the lid so the compiler will find new abuses if they creep in.

For non-CONFIG_CPUMASK_OFFSTACK:
   The only visible changes are that you have to use the accessors
   mm_cpumask() and tsk_cpumask.  They convert the bitmaps (moved to the end
   of those structs) to 'struct cpumask *'.

For CONFIG_CPUMASK_OFFSTACK=y:
   We allocate the mm and task_struct bitmaps short (nr_cpu_ids, rather
   than the compile-time NR_CPUS).  A couple of patches get rid of the
   old-style cpus_ ops so noone uses them accidentally.  We don't define
   struct cpumask at all, which prevents accidental abuse.  Finally, we
   reduce cpumask_size() so our dynamically-allocated cpumasks are only
   nr_cpu_ids big.

Cheers,
Rusty.
