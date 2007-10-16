Return-Path: <linux-kernel-owner+w=401wt.eu-S935446AbXJPS60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935446AbXJPS60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765378AbXJPS6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:58:16 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:37358 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbXJPS6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:58:15 -0400
Subject: Re: [patch 2/3] Introduce BOOTMEM_EXCLUSIVE
From: Dave Hansen <haveblue@us.ibm.com>
To: Bernhard Walle <bwalle@suse.de>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       akpm@linux-foundation.org, ak@suse.de
In-Reply-To: <20071016184440.GA19844@suse.de>
References: <20071016162857.635479952@strauss.suse.de>
	 <20071016162858.545617122@strauss.suse.de>
	 <1192558097.17464.15.camel@localhost>  <20071016184440.GA19844@suse.de>
Content-Type: text/plain
Date: Tue, 16 Oct 2007 11:58:13 -0700
Message-Id: <1192561093.17464.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-16 at 20:44 +0200, Bernhard Walle wrote:
> * Dave Hansen <haveblue@us.ibm.com> [2007-10-16 20:08]:
> > On Tue, 2007-10-16 at 18:28 +0200, Bernhard Walle wrote:
> > > 
> > > @@ -736,7 +736,7 @@ static int __init smp_scan_config (unsig
> > >                         smp_found_config = 1;
> > >                         printk(KERN_INFO "found SMP MP-table at %08lx\n",
> > >                                                 virt_to_phys(mpf));
> > > -                       reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE);
> > > +                       reserve_bootmem(virt_to_phys(mpf), PAGE_SIZE, 0);
> > >                         if (mpf->mpf_physptr) {
> > >                                 /* 
> > 
> > Could you give all of these 0's a name?  I really hate seeing random
> > magic numbers in these things.  0 completely kills the ability of
> > someone to read the code and figure out what it is trying to do without
> > going and looking at reserve_bootmem().
> 
> Of course I can replace that zeroes with something like BOOTMEM_DEFAULT.

Cool.

> > Or, alternatively, do something like this:
> > 
> > -extern void reserve_bootmem(unsigned long addr, unsigned long size);
> 
> Andi was against more bootmem functions. ;)

Yeah, I can't really blame him.

-- Dave

