Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbZDGVhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbZDGVhj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756514AbZDGVh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:37:29 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:35688 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbZDGVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:37:28 -0400
Date: Tue, 7 Apr 2009 17:31:57 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] slub: default min_partial to at least highest cpus per
  node
In-Reply-To: <49DBBC1F.6000407@cs.helsinki.fi>
Message-ID: <alpine.DEB.1.10.0904071728240.12192@qirst.com>
References: <alpine.DEB.2.00.0904051653420.25339@chino.kir.corp.google.com>  <49DBA23A.3000106@cs.helsinki.fi> <84144f020904071209j638aae9bv406661ec401af7af@mail.gmail.com> <alpine.DEB.2.00.0904071231500.21113@chino.kir.corp.google.com> <49DBAF7E.30704@cs.helsinki.fi>
 <alpine.DEB.2.00.0904071302430.32321@chino.kir.corp.google.com> <49DBB373.5050800@cs.helsinki.fi> <alpine.DEB.2.00.0904071316460.21748@chino.kir.corp.google.com> <49DBB929.4080205@cs.helsinki.fi> <alpine.DEB.1.10.0904071641390.12192@qirst.com>
 <49DBBC1F.6000407@cs.helsinki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009, Pekka Enberg wrote:

> Christoph Lameter wrote:
> > I am not sure about the benefit of this. If the page allocator finally
> > improves in performance then we can reduce the mininum number of partial
> > slabs kept and also do pass through for all sizes >2k.
>
> Sure, we can do that, but it still makes sense to adjust the partial list
> sizes based on per-node CPU count. So I'm inclined to apply the patch I
> suggested if it shows performance gains on one or more of the relevant
> benchmarks (sysbench, tbench, hackbench, netperf, etc.).

The partial list sizes cannot be adjusted. There is just a mininum size
that is set via MIN_PARTIAL. Currently we use that to avoid trips to the
page allocator by keeping the list artificially long. This should not be
done because it increases memory overhead by keeping slab pages around
with no objects. If the page allocator trips are not that expensive
anymore then there is no reason to keep these slab pages around. A hot
page can be reused by any other subsystemm in the kernel.

