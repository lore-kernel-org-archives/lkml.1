Return-Path: <linux-kernel-owner+w=401wt.eu-S932856AbYFFVL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856AbYFFVL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbYFFVLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:11:46 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:38657 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759405AbYFFVLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:11:45 -0400
Date: Fri, 6 Jun 2008 17:11:43 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, npiggin@suse.de, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu, paulmck@linux.vnet.ibm.com,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>
Subject: Re: [PATCH 9/10] parisc: convert to generic helpers for IPI
	function calls
Message-ID: <20080606211143.GA20770@phobos.i.cabal.ca>
References: <1212051504-12561-1-git-send-email-jens.axboe@oracle.com> <1212051504-12561-10-git-send-email-jens.axboe@oracle.com> <20080531070049.GA6623@phobos.i.cabal.ca> <20080602081749.GG5757@kernel.dk> <20080602160943.GB25011@phobos.i.cabal.ca> <20080606084743.GL5757@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606084743.GL5757@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 10:47:43AM +0200, Jens Axboe wrote:
> > Thanks, I'll try it out this evening.
> 
> How did that go?
> 

Ah, sorry, I forgot to mention that. Seems to be working fine, at least,
I'm getting jobs scheduled on each cpu, afaict.

Needed this patch though, and from the looks of things, a bunch of other
architectures will need it as well.

Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>

diff --git a/include/asm-parisc/smp.h b/include/asm-parisc/smp.h
index 306f495..ad24e7f 100644
--- a/include/asm-parisc/smp.h
+++ b/include/asm-parisc/smp.h
@@ -62,4 +62,7 @@ static inline void __cpu_die (unsigned int cpu) {
 }
 extern int __cpu_up (unsigned int cpu);
 
+void arch_send_call_function_ipi(cpumask_t mask);
+void arch_send_call_function_single_ipi(int cpu);
+
 #endif /*  __ASM_SMP_H */
