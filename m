Return-Path: <linux-kernel-owner+w=401wt.eu-S1761160AbYBMUgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761160AbYBMUgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 15:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755417AbYBMUgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 15:36:44 -0500
Received: from relay1.sgi.com ([192.48.171.29]:40894 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756473AbYBMUgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 15:36:42 -0500
Date: Wed, 13 Feb 2008 12:36:42 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
cc: Roland Dreier <rdreier@cisco.com>, Rik van Riel <riel@redhat.com>,
       steiner@sgi.com, Andrea Arcangeli <andrea@qumranet.com>,
       a.p.zijlstra@chello.nl, izike@qumranet.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Robin Holt <holt@sgi.com>,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: [ofa-general] Re: Demand paging for memory regions
In-Reply-To: <20080213195144.GE31435@obsidianresearch.com>
Message-ID: <Pine.LNX.4.64.0802131232330.20156@schroedinger.engr.sgi.com>
References: <ada3arzxgkz.fsf_-_@cisco.com> <47B2174E.5000708@opengridcomputing.com>
 <Pine.LNX.4.64.0802121408150.9591@schroedinger.engr.sgi.com>
 <adazlu5vlub.fsf@cisco.com> <20080212232329.GC31435@obsidianresearch.com>
 <Pine.LNX.4.64.0802121657430.11628@schroedinger.engr.sgi.com>
 <20080213012638.GD31435@obsidianresearch.com>
 <Pine.LNX.4.64.0802121819530.12328@schroedinger.engr.sgi.com>
 <20080213032533.GC32047@obsidianresearch.com>
 <Pine.LNX.4.64.0802131039160.18472@schroedinger.engr.sgi.com>
 <20080213195144.GE31435@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2008, Jason Gunthorpe wrote:

> Unfortunately it really has little to do with the drivers - changes,
> for instance, need to be made to support this in the user space MPI
> libraries. The RDMA ops do not pass through the kernel, userspace
> talks directly to the hardware which complicates building any sort of
> abstraction.

Ok so the notifiers have to be handed over to the user space library that 
has the function of the device driver here...

> That is where I think you run into trouble, if you ask the MPI people
> to add code to their critical path to support swapping they probably
> will not be too interested. At a minimum to support your idea you need
> to check on every RDMA if the remote page is mapped... Plus the
> overheads Christian was talking about in the OOB channel(s).

You only need to check if a handle has been receiving invalidates. If not 
then you can just go ahead as now. You can use the notifier to take down 
the whole region if any reclaim occur against it (probably best and 
simples to implement approach). Then you mark the handle so that the 
mapping is reestablished before the next operation.


