Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYFNUbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYFNUbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 16:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYFNUbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 16:31:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10349 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754301AbYFNUbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 16:31:13 -0400
Date: Sat, 14 Jun 2008 22:31:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, chrisw@sous-sol.org,
       virtualization@lists.osdl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 13 (XEN)
Message-ID: <20080614203109.GH20851@kernel.dk>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au> <20080613101316.1c228fe7.randy.dunlap@oracle.com> <4852F1C8.7060904@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4852F1C8.7060904@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13 2008, Jeremy Fitzhardinge wrote:
> Randy Dunlap wrote:
> >next-20080613 on x86_32 has lots of xen build errors like this:
> >
> >linux-next-20080613/arch/x86/xen/mmu.c: In function 'drop_mm_ref':
> >linux-next-20080613/arch/x86/xen/mmu.c:759: error: implicit declaration of 
> >function 'xen_smp_call_function_mask'
> >make[2]: *** [arch/x86/xen/mmu.o] Error 1
> >
> >  
> 
> Ooh, first time I've seen that.  Sounds like Jens' patches are missing 
> the appropriate update there (though it's certainly had it in the past).

Hmm, will this work or do we need to force xen smp_ops for this one? I
wonder if this is new code and was missed, or what happened in this
case.

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 3525ef5..8baef77 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -569,7 +569,7 @@ static void drop_mm_ref(struct mm_struct *mm)
 	}
 
 	if (!cpus_empty(mask))
-		xen_smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
+		smp_call_function_mask(mask, drop_other_mm_ref, mm, 1);
 }
 #else
 static void drop_mm_ref(struct mm_struct *mm)

-- 
Jens Axboe

