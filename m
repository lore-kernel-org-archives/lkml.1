Return-Path: <linux-kernel-owner+w=401wt.eu-S1752178AbYCLKfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbYCLKfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 06:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYCLKfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 06:35:38 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au ([203.59.1.107]:15344
	"EHLO outbound.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750992AbYCLKfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 06:35:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmABADhP10d8qMER/2dsb2JhbAAIqUE
X-IronPort-AV: E=Sophos;i="4.25,487,1199631600"; 
   d="scan'208";a="288471151"
Subject: Re: [PATCH] UIO: Implement a UIO interface for the SMX Cryptengine
From: Ben Nizette <bn@niasdigital.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: gregkh@suse.de, linux-kernel <linux-kernel@vger.kernel.org>,
       hjk@linutronix.de
In-Reply-To: <20080312100831.GB21854@linux-sh.org>
References: <1205211430.3817.15.camel@moss.renham>
	 <20080312100831.GB21854@linux-sh.org>
Content-Type: text/plain
Organization: Nias Digital
Date: Wed, 12 Mar 2008 21:41:08 +1100
Message-Id: <1205318468.4344.23.camel@moss.renham>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 19:08 +0900, Paul Mundt wrote:
> On Tue, Mar 11, 2008 at 03:57:10PM +1100, Ben Nizette wrote:
> > +
> > +	info->mem[0].size = regs->end - regs->start;
> > +	info->mem[0].memtype = UIO_MEM_PHYS;
> > +
> You have an off-by-1 in the resource size. ioremap and struct resource
> are not equal in their expectations. You probably want to do something
> like:
> 
> 	info->mem[0].size = regs->end - regs->start + 1;
> 	info->mem[0].internal_addr = ioremap(regs->start, info->mem[0].size);
> 	...
> 
You're right, thanks.  I hadn't noticed since we don't actually access
all the way to the end of the region in normal use.

> and make sure that your resource end doesn't overlap with a start address
> of an unrelated resource in your definition. /proc/iomem tends to be
> useful for this.

Yup.  In our case this is fairly easy as the engine just takes up a
whole Chip Select's worth of address space on an AVR32 AT32AP7000.

		--Ben.
