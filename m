Return-Path: <linux-kernel-owner+w=401wt.eu-S933965AbYBGA5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933965AbYBGA5d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:57:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964793AbYBGAyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:54:03 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:18661 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934548AbYBGAx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:53:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=fEoceINA04a14wJxz+iO3m0HhdlZgunkHGtICiJ0OnihsNaxNzwJ1cqBf0kP4X8AGEBeM7ftZyRPLot4cNVTGJtHmdNCVVcEcliMOOtPF8ef5zoRhtKYnILOVoc8vvJPhsdAA3B5qkmmWXx6FCgK/trjb4SHy1GiCbw3T33yaY4=
Date: Thu, 7 Feb 2008 02:51:20 +0200
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russel <rusty@rustcorp.com.au>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] lguest: Accept guest _PAGE_PWT page table entries
Message-ID: <20080207005120.GA5751@ubuntu>
References: <20080206232134.GB6450@ubuntu> <20080206235923.GA19843@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080206235923.GA19843@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 12:59:23AM +0100, Ingo Molnar wrote:
> 
> * Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> 
> > Hi all,
> > 
> > Beginning from commit 4138cc3418f5, ioremap_nocache() sets the _PAGE_PWT
> > flag. 
> > 
> > Lguest doesn't accept a guest pte with a _PWT flag and reports a "bad 
> > page table entry" in that case.
> > 
> > I've removed check from lguest code and everything worked fine. Is 
> > this safe from the Lguest side ?
> 
> yes, should be safe. Could you send a patch so that others can apply it 
> too?
> 

Ofcourse :) :

Accept guest _PAGE_PWT page table entries, otherwise lguest will
always fail with a "bad page table entry" message.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---

diff --git a/drivers/lguest/page_tables.c b/drivers/lguest/page_tables.c
index 74b4cf2..952160b 100644
--- a/drivers/lguest/page_tables.c
+++ b/drivers/lguest/page_tables.c
@@ -178,8 +178,8 @@ static void release_pte(pte_t pte)
 
 static void check_gpte(struct lg_cpu *cpu, pte_t gpte)
 {
-	if ((pte_flags(gpte) & (_PAGE_PWT|_PAGE_PSE))
-	    || pte_pfn(gpte) >= cpu->lg->pfn_limit)
+	if ((pte_flags(gpte) & _PAGE_PSE) || 
+	    pte_pfn(gpte) >= cpu->lg->pfn_limit)
 		kill_guest(cpu, "bad page table entry");
 }
 

Regards,

--
Ahmed S. Darwish
Homepage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
