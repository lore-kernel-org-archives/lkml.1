Return-Path: <linux-kernel-owner+w=401wt.eu-S933419AbYB2VD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419AbYB2VD3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 16:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752496AbYB2VDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 16:03:21 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37480 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751708AbYB2VDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 16:03:20 -0500
Date: Fri, 29 Feb 2008 13:03:16 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org,
       Robin Holt <holt@sgi.com>, Avi Kivity <avi@qumranet.com>,
       Izik Eidus <izike@qumranet.com>, kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com
Subject: Re: [patch 2/6] mmu_notifier: Callbacks to invalidate address ranges
In-Reply-To: <20080229201744.GB8091@v2.random>
Message-ID: <Pine.LNX.4.64.0802291301530.11889@schroedinger.engr.sgi.com>
References: <20080228001104.GB8091@v2.random>
 <Pine.LNX.4.64.0802271613080.15791@schroedinger.engr.sgi.com>
 <20080228005249.GF8091@v2.random> <Pine.LNX.4.64.0802271702490.16510@schroedinger.engr.sgi.com>
 <20080228011020.GG8091@v2.random> <Pine.LNX.4.64.0802281043430.29191@schroedinger.engr.sgi.com>
 <20080229005530.GO8091@v2.random> <Pine.LNX.4.64.0802281658560.1954@schroedinger.engr.sgi.com>
 <20080229131302.GT8091@v2.random> <Pine.LNX.4.64.0802291149290.11292@schroedinger.engr.sgi.com>
 <20080229201744.GB8091@v2.random>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Feb 2008, Andrea Arcangeli wrote:

> Agreed. I just thought xpmem needed an invalidate-by-page, but
> I'm glad if xpmem can go in sync with the KVM/GRU/DRI model in this
> regard.

That means we need both the anon_vma locks and the i_mmap_lock to become 
semaphores. I think semaphores are better than mutexes. Rik and Lee saw 
some performance improvements because list can be traversed in parallel 
when the anon_vma lock is switched to be a rw lock.

Sounds like we get to a conceptually clean version here?

