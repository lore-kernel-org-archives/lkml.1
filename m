Return-Path: <linux-kernel-owner+w=401wt.eu-S1762481AbYARPzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762481AbYARPzG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 10:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758959AbYARPyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 10:54:54 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:22698 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbYARPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 10:54:53 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: huang ying <huang.ying.caritas@gmail.com>,
       "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <4790BD90.9060303@zytor.com>
References: <1200375906.3505.30.camel@caritas-dev.intel.com>
	 <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
	 <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
	 <4790BD90.9060303@zytor.com>
Content-Type: text/plain
Date: Fri, 18 Jan 2008 15:54:25 +0000
Message-Id: <1200671665.9891.45.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 217.46.209.99
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced
	bt_ioremap - enhance bt_ioremap
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-01-18 at 09:54 -0500, H. Peter Anvin wrote:
> huang ying wrote:
> > 
> > If CONFIG_X86_PAE is defined, the set_pte, clear_pte etc will operate
> > 3-level page tables, while on i386, the early page table is always
> > 2-level, so set_pte, clear_pte etc functions can not be used here. The
> > boot_ioremap use a trick to deal with this problem. The CONFIG_X86_PAE
> > is undefined in arch/x86/mm/boot_ioremap_32.c unconditionally, so the
> > 2-level page table handling function is always used.
> > 
> > Is the method used by boot_ioremap better for Xen?
> > 
> 
> Eric Biederman had a patchset that makes a PAE kernel use PAE page 
> tables from the start.  That is really The Right Thing[TM].

That's much saner than dup'ing up the early ioremap stuff to support
both PAE and non-PAE at runtime, which is about the only idea I've got
for fixing this right now...

I think I'll just back out the early_ioremap patches locally for now and
wait for Eric's patches which should cause the fix for this issue to
just fall out in the wash.

Ian.
-- 
Ian Campbell
Current Noise: Mistress - Mistress

Everything should be built top-down, except this time.

