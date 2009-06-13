Return-Path: <linux-kernel-owner+w=401wt.eu-S1755146AbZFMMFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbZFMMFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751255AbZFMMFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:05:33 -0400
Received: from ozlabs.org ([203.10.76.45]:35926 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbZFMMFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:05:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tony Luck <tony.luck@intel.com>
Subject: Re: [PULL] module and parameter
Date: Sat, 13 Jun 2009 21:35:31 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Amerigo Wang <amwang@redhat.com>,
       alex@shark-linux.de, David Miller <davem@davemloft.net>,
       rth@twiddle.net, sfr@canb.auug.org.au
References: <200906122205.57362.rusty@rustcorp.com.au> <12c511ca0906121405x5ccd0a60k4b804266a87a7896@mail.gmail.com> <200906131450.16211.rusty@rustcorp.com.au>
In-Reply-To: <200906131450.16211.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906132135.32552.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Jun 2009 02:50:15 pm Rusty Russell wrote:
> On Sat, 13 Jun 2009 06:35:46 am Tony Luck wrote:
> > On Fri, Jun 12, 2009 at 5:35 AM, Rusty Russell<rusty@rustcorp.com.au> wrote:
> > >      module: trim exception table on init free.
> >
> > This is causing build errors for ia64:

Unfortunately this has gone into Linus' tree already.  I have compile-tested
my previous patch for ia64, and it fixes compile at least.

> > I note that this commit has been reverted in linux-next.  What's going
> > on?

kisskb.ellerman.id.au says it's broken there, so it's applied.

While I've got your attention, there was another build break on ia64 in
linux-next, caused by removal of smp_call_function_mask.

Thanks,
Rusty.

Subject: ia64: convert last user of smp_call_function_mask

smp_call_function_many is the new version: it takes a pointer.  Also,
use mm accessor macro while we're changing this.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/arch/ia64/kernel/smp.c b/arch/ia64/kernel/smp.c
--- a/arch/ia64/kernel/smp.c
+++ b/arch/ia64/kernel/smp.c
@@ -301,7 +301,7 @@ smp_flush_tlb_mm (struct mm_struct *mm)
 		return;
 	}
 
-	smp_call_function_mask(mm->cpu_vm_mask,
+	smp_call_function_many(mm_cpumask(mm),
 		(void (*)(void *))local_finish_flush_tlb_mm, mm, 1);
 	local_irq_disable();
 	local_finish_flush_tlb_mm(mm);

