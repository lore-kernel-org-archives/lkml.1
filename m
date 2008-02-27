Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbYB0WLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbYB0WLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757771AbYB0WL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:11:26 -0500
Received: from relay2.sgi.com ([192.48.171.30]:46983 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758061AbYB0WLZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:11:25 -0500
Date: Wed, 27 Feb 2008 14:11:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Pete Wyckoff <pw@osc.edu>, Rik van Riel <riel@redhat.com>,
       Andrea Arcangeli <andrea@qumranet.com>, a.p.zijlstra@chello.nl,
       izike@qumranet.com, Roland Dreier <rdreier@cisco.com>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <20080214000103.GG31435@obsidianresearch.com>
Message-ID: <Pine.LNX.4.64.0802271409480.13186@schroedinger.engr.sgi.com>
References: <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com>
 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com> <20080212232329.GC31435@obsidianresearch.com>
 <Pine.LNX.4.64.0802121657430.11628@schroedinger.engr.sgi.com>
 <20080213012638.GD31435@obsidianresearch.com>
 <Pine.LNX.4.64.0802121819530.12328@schroedinger.engr.sgi.com>
 <20080213040905.GQ29340@mv.qlogic.com> <20080213232308.GB7597@osc.edu>
 <20080214000103.GG31435@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Jason Gunthorpe wrote:

> Christoph: It seemed to me you were first talking about
> freeing/swapping/faulting RDMA'able pages - but would pure migration
> as a special hardware supported case be useful like Catilan suggested?

That is a special case of the proposed solution. You could mlock the 
regions of interest. Those can then only be migrated but not swapped out.

However, I think we need some limit on the number of pages one can mlock. 
Otherwise the VM can get into a situation where reclaim is not possible 
because the majority of memory is either mlocked or pinned by I/O etc.

