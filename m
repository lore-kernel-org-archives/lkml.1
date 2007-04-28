Return-Path: <linux-kernel-owner+w=401wt.eu-S1030799AbXD1Fel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030799AbXD1Fel (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 01:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754704AbXD1Fel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 01:34:41 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:52914 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688AbXD1Fek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 01:34:40 -0400
Date: Sat, 28 Apr 2007 06:34:26 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Rohit Seth <rohitseth@google.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mike Stroyan <mike.stroyan@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Luck, Tony" <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fw: [PATCH] ia64: race flushing icache in do_no_page path
In-Reply-To: <1177723863.13482.379.camel@galaxy.corp.google.com>
Message-ID: <Pine.LNX.4.64.0704280620150.9554@blonde.wat.veritas.com>
References: <20070425205548.fd51b301.akpm@linux-foundation.org> 
 <46305A8D.2080003@yahoo.com.au> <20070426173544.GA30744@ldl.fc.hp.com> 
 <4631E49C.2030501@yahoo.com.au>  <Pine.LNX.4.64.0704271437570.14794@blonde.wat.veritas.com>
 <1177723863.13482.379.camel@galaxy.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 28 Apr 2007 05:34:39.0032 (UTC) FILETIME=[EA0DE380:01C78956]
X-Brightmail-Verdict: VlJEQwAAAAIAAAABAAAAAAAAAAEAAAAAAAAAB2luYm94AG1pa2Uuc3Ryb3lhbkBocC5jb20AbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZwBsaW51eC1pYTY0QHZnZXIua2VybmVsLm9yZwBha3BtQGxpbnV4LWZvdW5kYXRpb24ub3JnAHRvbnkubHVja0BpbnRlbC5jb20Abmlja3BpZ2dpbkB5YWhvby5jb20uYXUAcm9oaXRzZXRoQGdvb2dsZS5jb20A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Rohit Seth wrote:
> On Fri, 2007-04-27 at 15:18 +0100, Hugh Dickins wrote:
> 
> Right.  Extra flush_icache_page routines will add cost to archs that
> have non-null definition of this routine.  BTW, isn't flush_icache_page
> marked for deprecation?

Yes, flush_icache_page is marked for deprecation: but that's hardly
a reason to add another under a different name!  (Not quite what you
did, but...)

> lazy_mmu_prot_update was added specifically for notifying change in
> protection.  So, in a way it is closer to update_mmu_cache (Which is for
> change in mappings itself).  Though for ia64 implementation, this ends
> up flushing the icaches when needed.

The ia64 implementation is the only one which has any use for it, and
it's only interested when it's executable i.e. "lazy_mmu_prot_update"
is a name concealing some overdesign.

> Hopefully my reply is useful.

Yes, thanks Rohit, and I'll want to read through it again later.
In particular, I've now a better idea what's "lazy" about it.

Hugh
