Return-Path: <linux-kernel-owner+w=401wt.eu-S1756880AbXKTBfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbXKTBfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbXKTBf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:35:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42170 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbXKTBf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:35:26 -0500
Message-ID: <474239CA.20403@zytor.com>
Date: Mon, 19 Nov 2007 17:35:06 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: ak@suse.de, akpm@linux-foundation.org, travis@sgi.com,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 08/45] cpu alloc: x86 support
References: <20071120011132.143632442@sgi.com> <20071120011333.619991903@sgi.com>
In-Reply-To: <20071120011333.619991903@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> 
> For the UP and SMP case map the area using 4k ptes. Typical use of per cpu
> data is around 16k for UP and SMP configurations. It goes up to 45k when the
> per cpu area is managed by cpu_alloc (see special x86_64 patchset).
> Allocating in 2M segments would be overkill.
> 
> For NUMA map the area using 2M PMDs. A large NUMA system may use
> lots of cpu data for the page allocator data alone. We typically
> have large amounts of memory around on those size. Using a 2M page size
> reduces TLB pressure for that case.
> 
> Some numbers for envisioned maximum configurations of NUMA systems:
> 
> 4k cpu configurations with 1k nodes:
> 
> 	4096 * 16MB = 64TB of virtual space.
> 
> Maximum theoretical configuration 16384 processors 1k nodes:
> 
> 	16384 * 16MB = 256TB of virtual space.
> 
> Both fit within the established limits established.
> 

You're making the assumption here that NUMA = large number of CPUs. 
This assumption is flat-out wrong.

On x86-64, most two-socket systems are still NUMA, and I would expect 
that most distro kernels probably compile in NUMA.  However,
burning megabytes of memory on a two-socket dual-core system when we're 
talking about tens of kilobytes used would be more than a wee bit insane.

I do like the concept, overall, but the above distinction needs to be fixed.

	-hpa
