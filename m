Return-Path: <linux-kernel-owner+w=401wt.eu-S1754997AbZCDWqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbZCDWqt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 17:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752559AbZCDWql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 17:46:41 -0500
Received: from bilbo.ozlabs.org ([203.10.76.25]:60840 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385AbZCDWqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 17:46:40 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18863.1197.527693.75146@drongo.ozlabs.ibm.com>
Date: Thu, 5 Mar 2009 09:46:05 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] perfcounters: provide expansion room in the ABI
In-Reply-To: <20090304104945.GB4879@elte.hu>
References: <18862.19599.929591.3109@cargo.ozlabs.ibm.com>
	<20090304104945.GB4879@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (powerpc-unknown-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> > git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git rfc
> > 
> >  include/linux/perf_counter.h |   12 +++++++++---
> >  include/linux/syscalls.h     |    2 +-
> >  kernel/perf_counter.c        |   10 +++++++---
> >  3 files changed, 17 insertions(+), 7 deletions(-)
> 
> Pulled into tip:perfcounters/core, thanks Paul!

Actually, I goofed slightly.  In this bit of the patch:

@@ -80,10 +81,15 @@ struct perf_counter_hw_event {
 				exclude_user   :  1, /* don't count user      */
 				exclude_kernel :  1, /* ditto kernel          */
 				exclude_hv     :  1, /* ditto hypervisor      */
+				exclude_idle   :  1, /* don't count when idle */
 
-				__reserved_1 : 23;
+				__reserved_1 : 55;
+

the 55 should have been 54 if we want those bitfields to occupy 64
bits.  With 55 there, __reserved_1 will go in the next 64-bit
quadword (x86-speak, or doubleword in powerpc-speak).

Do you think that's worth changing?  If so I'll do a commit changing
the 55 to 54.

Paul.
