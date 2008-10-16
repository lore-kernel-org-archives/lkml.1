Return-Path: <linux-kernel-owner+w=401wt.eu-S1757464AbYJPTVX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757464AbYJPTVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 15:21:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYJPTVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 15:21:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255AbYJPTVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 15:21:14 -0400
Message-ID: <48F793F8.8090806@linux-foundation.org>
Date: Thu, 16 Oct 2008 14:20:24 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Oliver Weihe <o.weihe@deltacomputer.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Fw: NUMA allocator on Opteron systems does non-local allocation
 on node0
References: <20081015014125.a546fcc4.akpm@linux-foundation.org>
In-Reply-To: <20081015014125.a546fcc4.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've notived that the memory allocation on NUMA systems (Opterons) does
> memory allocation on non-local nodes for processes running node0 even if
> local memory is available. (Kernel 2.6.25 and above)

How much local memory is available? 8GB per node? That means there will be 4GB
on node 0 in ZONE_DMA32 and 4GB in ZONE_NORMAL. Other nodes will have 8GB in
ZONE_NORMAL.

> In my setup I'm allocating an array of ~7GiB memory size in a
> singlethreaded application.
> Startup: numactl --cpunodebind=X ./app
> For X=1,2,3 it works as expected, all memory is allocated on the local
> node.
> For X=0 I can see the memory beeing allocated on node0 as long as ~3GiB
> are "free" on node0. At this point the kernel starts using memory from
> node1 for the app!

NUMA only supports memory policies for the highest zone which is
ZONE_NORMAL here. Only 4GB of ZONE_NORMAL are available on node 0, so it will
go off node after that memory is exhausted. This is done in order to preserve
the lower 4GB for I/O to 32 bit devices.

