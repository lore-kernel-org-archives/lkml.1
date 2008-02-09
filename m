Return-Path: <linux-kernel-owner+w=401wt.eu-S1757786AbYBIANA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786AbYBIANA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 19:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYBIAMw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 19:12:52 -0500
Received: from sj-iport-3.cisco.com ([171.71.176.72]:26521 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753555AbYBIAMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 19:12:51 -0500
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, andrea@qumranet.com,
       a.p.zijlstra@chello.nl, linux-mm@kvack.org, izike@qumranet.com,
       steiner@sgi.com, linux-kernel@vger.kernel.org, avi@qumranet.com,
       kvm-devel@lists.sourceforge.net, daniel.blueman@quadrics.com,
       Robin Holt <holt@sgi.com>, general@lists.openfabrics.org
Subject: Re: [ofa-general] Re: [patch 0/6] MMU Notifiers V6
X-Message-Flag: Warning: May contain useful information
References: <20080208220616.089936205@sgi.com>
	<20080208142315.7fe4b95e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081528070.4036@schroedinger.engr.sgi.com>
	<20080208233636.GG26564@sgi.com>
	<Pine.LNX.4.64.0802081540180.4291@schroedinger.engr.sgi.com>
	<20080208234302.GH26564@sgi.com>
	<20080208155641.2258ad2c.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 08 Feb 2008 16:12:42 -0800
In-Reply-To: <Pine.LNX.4.64.0802081603430.4543@schroedinger.engr.sgi.com> (Christoph Lameter's message of "Fri, 8 Feb 2008 16:05:00 -0800 (PST)")
Message-ID: <adaprv70yyt.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.21 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Feb 2008 00:12:42.0816 (UTC) FILETIME=[7D3F7C00:01C86AB0]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > We have done several rounds of discussion on linux-kernel about this so 
 > far and the IB folks have not shown up to join in. I have tried to make 
 > this as general as possible.

Sorry, this has been on my "things to look at" list for a while, but I
haven't gotten a chance to really understand where things are yet.

In general, this MMU notifier stuff will only be useful to a subset of
InfiniBand/RDMA hardware.  Some adapters are smart enough to handle
changing the IO virtual -> bus/physical mapping on the fly, but some
aren't.  For the dumb adapters, I think the current ib_umem_get() is
pretty close to as good as we can get: we have to keep the physical
pages pinned for as long as the adapter is allowed to DMA into the
memory region.

For the smart adapters, we just need a chance to change the adapter's
page table when the kernel/CPU's mapping changes, and naively, this
stuff looks like it would work.

Andrew, does that help?

- R.
