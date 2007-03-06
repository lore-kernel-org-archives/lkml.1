Return-Path: <linux-kernel-owner+w=401wt.eu-S965975AbXCFS2K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965975AbXCFS2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:28:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965980AbXCFS2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:28:10 -0500
Received: from gw.goop.org ([64.81.55.164]:50324 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965975AbXCFS2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:28:08 -0500
Message-ID: <45EDB2B5.4000506@goop.org>
Date: Tue, 06 Mar 2007 10:28:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 8/8] Convert PDA into the percpu section
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain>	 <1173185734.4644.32.camel@localhost.localdomain>	 <1173185827.4644.34.camel@localhost.localdomain>	 <1173185909.4644.36.camel@localhost.localdomain>	 <1173186021.4644.38.camel@localhost.localdomain>	 <1173186107.4644.41.camel@localhost.localdomain> <1173186214.4644.44.camel@localhost.localdomain>
In-Reply-To: <1173186214.4644.44.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Currently x86 (similar to x84-64) has a special per-cpu structure
> called "i386_pda" which can be easily and efficiently referenced via
> the %fs register.  An ELF section is more flexible than a structure,
> allowing any piece of code to use this area.  Indeed, such a section
> already exists: the per-cpu area.
>
> So this patch
> (1) Removes the PDA and uses per-cpu variables for each current member.
> (2) Replaces the __KERNEL_PDA segment with __KERNEL_PERCPU.
> (3) Creates a per-cpu mirror of __per_cpu_offset called this_cpu_off, which
>     can be used to calculate addresses for this CPU's variables.
> (4) Moves the boot cpu's GDT/percpu setup to smp_prepare_boot_cpu(),
>     immediately after the per-cpu areas are allocated.
>
> The result is one less x86-specific concept.
>   

Looks good.  I think you can drop x86_add/sub/or_percpu; there are no users.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
