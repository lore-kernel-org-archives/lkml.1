Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbZCCU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbZCCU2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZCCU2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:28:09 -0500
Received: from smtp3.ultrahosting.com ([74.213.175.254]:34765 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753126AbZCCU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:28:08 -0500
Date: Tue, 3 Mar 2009 15:14:07 -0500 (EST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] slub: enforce cpuset restrictions for cpu slabs
In-Reply-To: <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0903031509380.25612@qirst.com>
References: <alpine.DEB.2.00.0903022009490.17284@chino.kir.corp.google.com> <alpine.DEB.2.00.0903022011430.17284@chino.kir.corp.google.com> <alpine.DEB.1.10.0903031136380.26454@qirst.com> <alpine.DEB.2.00.0903030900580.6643@chino.kir.corp.google.com>
 <alpine.DEB.1.10.0903031345150.9466@qirst.com> <alpine.DEB.2.00.0903031057110.15900@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Mar 2009, David Rientjes wrote:

> This change doesn't affect the fastpath in any significant way for systems
> that have not configured multiple cpusets; systems that have configured
> more than one cpuset may have specific NUMA locality requirements that
> slub is dismissing without this patch.

SLUB is also "dismissing" lots of other NUMA locality requirements since
it relies on the page allocators for this. SLUB does *not* realize memory
policy and/or cpuset support for individual objects. NUMA locality is
implemented only (aside from explicit requests of memory from a
certain node) when slab page allocations are performed.

