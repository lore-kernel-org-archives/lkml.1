Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbXCUGbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbXCUGbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 02:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752596AbXCUGbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 02:31:09 -0400
Received: from ozlabs.org ([203.10.76.45]:35769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbXCUGbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 02:31:07 -0400
Subject: [PATCH 0/4] i386 GDT cleanups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1174457426.11680.132.camel@localhost.localdomain>
References: <1174457426.11680.132.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 17:30:36 +1100
Message-Id: <1174458636.11680.143.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After lots of good feedback and contributions from the last series, this
set of 4 simply cleans up GDT usage in i386.  Percpu->pda is not
included: it's really a separate problem (but made much simpler by these
patches).

Patches are:
no-gdt-pda-alloc.patch 
        - Simplify by using per-cpu vars for gdt & pda, not allocating.
        This patch has been seen here before, and Jeremy Fitzhardinge
        acked it.

direct-percpu-gdt.patch 
        - Simplify boot by switching straight from boot_gdt_table
        straight to per-cpu versions, rather than going to cpu_gdt_table
        then per-cpu gdt.  This is a new approach after Ingo cautioned
        about removing boot_gdt_table.

cleanup-cpuinits.patch 
        - Simple patch: we can now roll two identical functions together
        
cleanup-gdt-accessors.patch 
        - Remove a level of indirection

Cheers,
Rusty.


