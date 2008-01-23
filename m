Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbYAWKpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbYAWKpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 05:45:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751899AbYAWKpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 05:45:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:54012 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYAWKpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:45:05 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Date: Wed, 23 Jan 2008 11:45:14 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: mingo@elte.hu, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       apw@shadowen.org
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <200801221433.29771.andi@firstfloor.org> <20080123102834.GC21455@csn.ul.ie>
In-Reply-To: <20080123102834.GC21455@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801231145.14915.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > i386 already has srat parsing code (just written in a horrible hackish
> > way); but it exists arch/x86/kernel/srat_32.c
>
> Yes, I spotted that. Enabling it required a Kconfig change 

does it? I was pretty sure that a !NUMAQ i386 CONFIG_NUMA build
already used that. At least that was the case when I last looked. If that
has changed it must have bitrotted recently.

> or two and 
> enabling BOOT_IOREMAP. It then crashes early in boot on a call to strlen()
> so I went with the stubs and SRAT disabled for the moment.

Crashed on a Opteron box? That was always the case

If it crashed on a (older) Summit then it likely bitrotted, because that 
worked at some point. The code was originally written by Pat G. for Summit1
and I believe was at least used by some people (no distributions) for S2,
possible 3 too.

> Ok, understood. When I next revisit this, I'll look at making ACPI_SRAT
> and BOOT_IOREMAP work on normal machines and see what happens. Thanks.

Again the problem shouldn't be normal machines, but non Summit NUMA systems.

-Andi

