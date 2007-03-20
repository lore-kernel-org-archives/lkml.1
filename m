Return-Path: <linux-kernel-owner+w=401wt.eu-S1751857AbXCTRXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbXCTRXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:23:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbXCTRXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:23:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:38260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbXCTRXb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:23:31 -0400
Date: Tue, 20 Mar 2007 19:22:33 +0100
From: Andi Kleen <ak@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>
Subject: Re: mm snapshot broken-out-2007-03-18-02-44.tar.gz uploaded
Message-ID: <20070320182233.GC4286@bingen.suse.de>
References: <200703180946.l2I9kTVc020636@shell0.pdx.osdl.net> <45FF8A79.7010201@googlemail.com> <20070320083627.27d90a91.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320083627.27d90a91.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 08:36:27AM -0800, Andrew Morton wrote:
> > caller is avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
> >  [<c0105256>] show_trace_log_lvl+0x1a/0x2f
> >  [<c010597b>] show_trace+0x12/0x14
> >  [<c0105a3d>] dump_stack+0x16/0x18
> >  [<c0213313>] debug_smp_processor_id+0xb3/0xc8
> >  [<c0116a26>] avail_to_resrv_perfctr_nmi_bit+0x2b/0x43
> >  [<fdc819b9>] nmi_create_files+0x2a/0x10e [oprofile]
> >  [<fdc80f52>] oprofile_create_files+0xe6/0xec [oprofile]
> >  [<fdc81157>] oprofilefs_fill_super+0x78/0x7e [oprofile]
> >  [<c0182d2e>] get_sb_single+0x59/0x9f
> >  [<fdc8108f>] oprofilefs_get_sb+0x1c/0x1e [oprofile]
> >  [<c0182792>] vfs_kern_mount+0x81/0xf1
> >  [<c0182852>] do_kern_mount+0x38/0xde
> >  [<c0196671>] do_mount+0x605/0x693
> >  [<c019677f>] sys_mount+0x80/0xb5
> >  [<c0104270>] syscall_call+0x7/0xb
> >  =======================
> 
> Odd.  It looks like oprofile has been doing this for some time.  Andi,
> there are a few changes in the NMI area - can you think of one whihc would
> have triggered this?

Looks like it was always broken. avail_to_resrv_perfctr_nmi_bit() must 
always do all this for all possible CPUs, not just the current one.
I can cook up a patch.

-Andi


