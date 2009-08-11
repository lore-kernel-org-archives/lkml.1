Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZHKMgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZHKMgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZHKMgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:36:49 -0400
Received: from gate.crashing.org ([63.228.1.57]:50527 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbZHKMgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:36:48 -0400
Subject: Re: [PATCH v2] powerpc: Allow perf_counters to access user memory
 at interrupt time
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <19066.25278.925555.133212@drongo.ozlabs.ibm.com>
References: <19066.25278.925555.133212@drongo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 11 Aug 2009 16:44:53 +1000
Message-Id: <1249973093.9841.107.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-06 at 14:57 +1000, Paul Mackerras wrote:
> This provides a mechanism to allow the perf_counters code to access
> user memory in a PMU interrupt routine.  Such an access can cause
> various kinds of interrupt: SLB miss, MMU hash table miss, segment
> table miss, or TLB miss, depending on the processor.  This commit
> only deals with the classic/server processors that use an MMU hash
> table, not processors that have software-loaded TLBs.

 .../...

> Signed-off-by: Paul Mackerras <paulus@samba.org>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

As discussed in the lab, you should also do a pre-req patch to pgtable.h
that changes ppc32 with 64-bit PTE without CONFIG_SMP to use the same
path as SMP to order the stores to the two halves of the PTEs though.

Cheers,
Ben.

