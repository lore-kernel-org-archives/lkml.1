Return-Path: <linux-kernel-owner+w=401wt.eu-S1759261AbYD2Puo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261AbYD2Puo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYD2Pud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:50:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:34312 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753018AbYD2Puc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:50:32 -0400
Date: Tue, 29 Apr 2008 10:50:30 -0500
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Jack Steiner <steiner@sgi.com>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       kvm-devel@lists.sourceforge.net, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       Roland Dreier <rdreier@cisco.com>,
       Steve Wise <swise@opengridcomputing.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, linux-mm@kvack.org,
       general@lists.openfabrics.org, Hugh Dickins <hugh@veritas.com>,
       akpm@linux-foundation.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 01 of 12] Core of mmu notifiers
Message-ID: <20080429155030.GB28944@sgi.com>
References: <20080424064753.GH24536@duo.random> <20080424095112.GC30298@sgi.com> <20080424153943.GJ24536@duo.random> <20080424174145.GM24536@duo.random> <20080426131734.GB19717@sgi.com> <20080427122727.GO9514@duo.random> <Pine.LNX.4.64.0804281332030.31163@schroedinger.engr.sgi.com> <20080429001052.GA8315@duo.random> <Pine.LNX.4.64.0804281819020.2502@schroedinger.engr.sgi.com> <20080429153052.GE8315@duo.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080429153052.GE8315@duo.random>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I however doubt this will bring us back to the same performance of the
> current spinlock version, as the real overhead should come out of
> overscheduling in down_write ai anon_vma_link. Here an initially
> spinning lock would help but that's gray area, it greatly depends on
> timings, and on very large systems where a cacheline wait with many
> cpus forking at the same time takes more than scheduling a semaphore
> may not slowdown performance that much. So I think the only way is a
> configuration option to switch the locking at compile time, then XPMEM
> will depend on that option to be on, I don't see a big deal and this
> guarantees embedded isn't screwed up by totally unnecessary locks on UP.

You have said this continually about a CONFIG option.  I am unsure how
that could be achieved.  Could you provide a patch?

Thanks,
Robin
