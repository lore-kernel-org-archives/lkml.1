Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbYAVMOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbYAVMOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 07:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbYAVMOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 07:14:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35571 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYAVMOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 07:14:16 -0500
Date: Tue, 22 Jan 2008 13:14:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080122121400.GB31253@elte.hu>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <p73hcha9vc5.fsf@bingen.suse.de> <20080119160743.GA8352@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119160743.GA8352@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> [...] I tested this situation on a 4-node NUMA Opteron box. It didn't 
> work very well based on a few problems.
> 
> - alloc_remap() and SPARSEMEM on HIGHMEM4G explodes [1]
> - Without SRAT, there is a build failure 
> - Enabling SRAT requires BOOT_IOREMAP and it explodes early in boot
> 
> I have one fix for items 1 and 2 with the patch below. It probably 
> should be split in two but lets see if we want to pursue alternative 
> fixes to this problem first. In particular, this patch stops SPARSEMEM 
> using alloc_remap() because not enough memory is set aside. An 
> alternative solution may be to reserve more for alloc_remap() when 
> SPARSEMEM is in use.
> 
> With the patch applied, an x86-64 capable NUMA Opteron box will boot a 
> 32 bit NUMA enabled kernel with DISCONTIGMEM or SPARSEMEM. Due to the 
> lack of SRAT parsing, there is only node 0 of course.
> 
> Based on this, I have no doubt there is going to be a series of broken 
> boots while stuff like this gets rattled out. For the moment, NUMA on 
> x86 32-bit should remain CONFIG_EXPERIMENTAL.

thanks, applied.

	Ingo
