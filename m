Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0BFHZO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 02:25:14 -0500
Received: from one.firstfloor.org ([213.235.205.2]:48436 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0BFHZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 02:25:12 -0500
Date: Sat, 6 Feb 2010 08:25:08 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Rientjes <rientjes@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, submit@firstfloor.org,
       linux-kernel@vger.kernel.org, haicheng.li@intel.com,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org
Subject: Re: [PATCH] [1/4] SLAB: Handle node-not-up case in fallback_alloc()
Message-ID: <20100206072508.GN29555@one.firstfloor.org>
References: <201002031039.710275915@firstfloor.org> <20100203213912.D3081B1620@basil.firstfloor.org> <alpine.DEB.2.00.1002051251390.2376@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1002051251390.2376@chino.kir.corp.google.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 05, 2010 at 01:06:56PM -0800, David Rientjes wrote:
> On Wed, 3 Feb 2010, Andi Kleen wrote:
> 
> > When fallback_alloc() runs the node of the CPU might not be initialized yet.
> > Handle this case by allocating in another node.
> > 
> 
> That other node must be allowed by current's cpuset, otherwise 
> kmem_getpages() will fail when get_page_from_freelist() iterates only over 
> unallowed nodes.

All theses cases are really only interesting in the memory hotplug path
itself (afterwards the slab is working anyways and memory is there)
and if someone sets funny cpusets for those he gets what he deserves ...

-Andi
