Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbYATSEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbYATSEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbYATSEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:04:35 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:13594 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYATSEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:04:34 -0500
Date: Sun, 20 Jan 2008 19:04:32 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: mingo@elte.hu, Jeremy Fitzhardinge <jeremy@goop.org>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com
Subject: Re: [PATCH] Fix early_ioremap on x86-64 II
Message-ID: <20080120180431.GA7452@basil.nowhere.org>
References: <20080120172840.GA24608@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080120172840.GA24608@basil.nowhere.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 20 Jan 2008 17:58:19.0125 (UTC) FILETIME=[09FF0250:01C85B8E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch changes all flushes in init_64.c to be __flush_tlb_all()
> and fixes the problem here.

Hmm, I see new early crashes with that patch here in some cases unfortunately:

PANIC: early exception 06 rip 10:ffffffff8082df2d error 0 cr2 0
Pid: 0, comm: swapper Not tainted 2.6.24-rc8-g7ada4254 #39

Call Trace:
 [<ffffffff8082df2d>] free_bootmem_core+0x1a/0x6b
 [<ffffffff8082f143>] free_bootmem_with_active_regions+0x51/0x67
 [<ffffffff8082a0f3>] setup_node_bootmem+0x16b/0x1b3
 [<ffffffff8082b3a4>] acpi_scan_nodes+0x136/0x230
 [<ffffffff8082a6bb>] numa_initmem_init+0x331/0x459
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff80355726>] number+0x10e/0x1f9
 [<ffffffff802354d8>] printk+0x4e/0x56
 [<ffffffff80355726>] number+0x10e/0x1f9
 [<ffffffff803563f8>] vsnprintf+0x53f/0x583
 [<ffffffff80355726>] number+0x10e/0x1f9
 [<ffffffff80234ef6>] release_console_sem+0x1b4/0x1cd
 [<ffffffff803563f8>] vsnprintf+0x53f/0x583
 [<ffffffff8022468a>] early_serial_write+0x22/0x32

Not sure what's going wrong. I think the patch is correct, but there
are probably more bugs around triggered by some change. Perhaps it is 
better to just revert Jeremy's patch (789bad4ca2b604f2f21ae7e3d64b67325ec8f9bb) for now.

-Andi
