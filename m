Return-Path: <linux-kernel-owner+w=401wt.eu-S932414AbZKRSfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932414AbZKRSfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758206AbZKRSf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:35:29 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:41555 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758203AbZKRSf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:35:29 -0500
Date: Wed, 18 Nov 2009 10:35:24 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Gary Hade <garyhade@us.ibm.com>,
       Badari Pulavarty <pbadari@us.ibm.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch -mm] mm: slab allocate memory section nodemask for
	large systems
Message-ID: <20091118183523.GA7793@us.ibm.com>
References: <alpine.DEB.2.00.0911171618430.25821@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0911171618430.25821@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Tue, Nov 17, 2009 at 04:19:30PM -0800, David Rientjes wrote:
> Nodemasks should not be allocated on the stack for large systems (when it
> is larger than 256 bytes) since there is a threat of overflow.
> 
> This patch causes the unregister_mem_sect_under_nodes() nodemask to be
> allocated on the stack for smaller systems and be allocated by slab for
> larger systems.

I notice that there are many other functions that always allocate
nodemask_t objects on the stack.  In addition to several that add
a single instance to the stack, cpuset_attach() in kernel/cpuset.c
adds 2 instances and all that are created by using SYSCALL_DEFINE4()
in mm/mempolicy.c add 3 instances.  Are there plans to correct the
other functions as well or is there something about
unregister_mem_sect_under_nodes() that makes it more likely to
cause stack overflows than the others?

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

