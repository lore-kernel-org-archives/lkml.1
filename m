Return-Path: <linux-kernel-owner+w=401wt.eu-S1765507AbYD2QD5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765507AbYD2QD5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 12:03:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751968AbYD2QDp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 12:03:45 -0400
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:46023
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764923AbYD2QDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 12:03:42 -0400
Date: Tue, 29 Apr 2008 18:03:40 +0200
From: Andrea Arcangeli <andrea@qumranet.com>
To: Robin Holt <holt@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080429160340.GG8315@duo.random>
References: <20080424095112.GC30298@sgi.com> <20080424153943.GJ24536@duo.random> <20080424174145.GM24536@duo.random> <20080426131734.GB19717@sgi.com> <20080427122727.GO9514@duo.random> <Pine.LNX.4.64.0804281332030.31163@schroedinger.engr.sgi.com> <20080429001052.GA8315@duo.random> <Pine.LNX.4.64.0804281819020.2502@schroedinger.engr.sgi.com> <20080429153052.GE8315@duo.random> <20080429155030.GB28944@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429155030.GB28944@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 10:50:30AM -0500, Robin Holt wrote:
> You have said this continually about a CONFIG option.  I am unsure how
> that could be achieved.  Could you provide a patch?

I'm busy with the reserved ram patch against 2.6.25 and latest kvm.git
that is moving from pages to pfn for pci passthrough (that change will
also remove the page pin with mmu notifiers).

Unfortunately reserved-ram bugs out again in the blk-settings.c on
real hardware. The fix I pushed in .25 for it, works when booting kvm
(that's how I tested it) but on real hardware sata b_pfn happens to be
1 page less than the result of the min comparison and I'll have to
figure out what happens (only .24 code works on real hardware..., at
least my fix is surely better than the previous .25-pre code).

I've other people waiting on that reserved-ram to be working, so once
I've finished, I'll do the optimization to anon-vma (at least the
removal of the unnecessary atomic_inc from fork) and add the config
option.

Christoph if you've interest in evolving anon-vma-sem and i_mmap_sem
yourself in this direction, you're very welcome to go ahead while I
finish sorting out reserved-ram. If you do, please let me know so we
don't duplicate effort, and it'd be absolutely great if the patches
could be incremental with #v14 so I can merge them trivially later and
upload a new patchset once you're finished (the only outstanding fix
you have to apply on top of #v14 that is already integrated in my
patchset, is the i_mmap_sem deadlock fix I posted and that I'm sure
you've already applied on top of #v14 before doing any more
development on it).

Thanks!
