Return-Path: <linux-kernel-owner+w=401wt.eu-S1753591AbYAWK2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591AbYAWK2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:28:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbYAWK2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:28:37 -0500
Received: from gir.skynet.ie ([193.1.99.77]:38492 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbYAWK2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:28:36 -0500
Date: Wed, 23 Jan 2008 10:28:34 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080123102834.GC21455@csn.ul.ie>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <p73hcha9vc5.fsf@bingen.suse.de> <20080119160743.GA8352@csn.ul.ie> <200801221433.29771.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200801221433.29771.andi@firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (22/01/08 14:33), Andi Kleen didst pronounce:
> 
> > Without SRAT support, a compile-error occurs because ACPI table parsing
> > functions are only available in x86-64. This patch also adds no-op stubs
> > and prints a warning message. What likely needs to be done is sharing
> > the table parsing functions between 32 and 64 bit if they are
> > compatible.
> 
> I'm a little confused by your patch.
> 
> i386 already has srat parsing code (just written in a horrible hackish way); 
> but it exists arch/x86/kernel/srat_32.c
> 

Yes, I spotted that. Enabling it required a Kconfig change or two and
enabling BOOT_IOREMAP. It then crashes early in boot on a call to strlen()
so I went with the stubs and SRAT disabled for the moment.

> That one tended to explode on Opteron, but apparently worked on some 
> Summit boxes.
> 
> You're saying you want to remove that code and replace it based on something
> based on the drivers/acpi/numa.c parsing code?

I made the assumption that they were basically the same. That is obviously
wrong from what you say below.

> While that's in theory
> a worthy goal it will not actually help all that much because numa.c only
> does some high level parsing, but nothing of the actual low level work
> of setting things up.
> 

Ok, understood. When I next revisit this, I'll look at making ACPI_SRAT
and BOOT_IOREMAP work on normal machines and see what happens. Thanks.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
