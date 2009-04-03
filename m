Return-Path: <linux-kernel-owner+w=401wt.eu-S934964AbZDCRpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934964AbZDCRpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 13:45:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbZDCRpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 13:45:08 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61112 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760153AbZDCRpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 13:45:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B1bq/zSfdPbtGp3fnvsa3Z1aw/JQJ98UGhMUxzaZJzEEZQh2ZHWQVG+OZCO6GyN+1u
         z+nzj/O/W2+G2nX9FEPGTsOPv7sXHGZGXqmuL8ho6DoXOrTSEL0rqACzXlbr7taFWfa/
         dIOTPG+ENHkVKGWY+TCGyCXGx1f9V2sjtthHU=
Subject: Re: [patch 00/20] x86, ptrace, bts, hw-branch-tracer: fixes and
	cleanups
From: Markus Metzger <markus.t.metzger@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: markus.t.metzger@intel.com, tglx@linutronix.de, hpa@zytor.com,
       roland@redhat.com, eranian@googlemail.com, oleg@redhat.com,
       juan.villacis@intel.com, ak@linux.jf.intel.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090403153617.GA15166@elte.hu>
References: <20090403144332.799740000@intel.com>
	 <20090403153617.GA15166@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 03 Apr 2009 19:44:53 +0200
Message-Id: <1238780693.6224.5.camel@raistlin>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 17:36 +0200, Ingo Molnar wrote: 
> * markus.t.metzger@intel.com <markus.t.metzger@intel.com> wrote:
> 
> > Patches 1-5 fix races with context switching code when the branch 
> > traced task is currently running.
> > 
> > In the worst case, this might cause context switch code to access 
> > freed memory or the tracing hardware to continue tracing into a 
> > freed buffer. Both might crash the kernel.
> > 
> > The first 4 patches apply to .29 using the below preparation 
> > patch.
> > 
> > The remaining patches fix bugs in the context of per-cpu tracing 
> > (i.e. hw-branch-tracer) and pebs, add more selftest code, and do 
> > some cleanups.
> 
> Thanks - this looks pretty acceptable. Latest -git changed a lot of 
> code in the same area (-mm bits went upstream), creating a lot of 
> conflicts.
> 
> To not prolongue this any longer (20 patches are difficult enough 
> already to handle) i picked up your patches and resolved the 
> conflicts in situ - mind having a look at the resulting 
> tip:tracing/hw-branch-tracing branch - does the end result look sane 
> to you?

Thanks,

The branch tracing bits in tip/tracing/hw-branch-tracing look good.
The kernel boots (after changes, see below) and my tests pass.

A defconfig build fails with a compile error, though:
In file included from net/core/skbuff.c:68:
include/trace/skb.h:7: error: expected ‘)’ before ‘(’ token
.....

Changing TP~ to TP_~ (as in tip/master) seems to do the trick.


> It would also be nice to address Peter's feedback about the mm.h 
> detail and the locked-pages API - but we can do that on top.

I will address them, though not immediately (vacation).


thanks and regards,
markus.

