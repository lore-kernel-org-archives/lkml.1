Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbXKPDK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbXKPDK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 22:10:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbXKPDKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 22:10:17 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50590 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754154AbXKPDKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 22:10:15 -0500
Date: Thu, 15 Nov 2007 19:10:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: David Miller <davem@davemloft.net>
cc: corbet@lwn.net, andi@firstfloor.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       schwidefsky@de.ibm.com
Subject: Re: [patch 01/28] cpu alloc: The allocator
In-Reply-To: <20071115.185854.85318344.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0711151902130.322@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0711151816170.31691@schroedinger.engr.sgi.com>
 <20071115.185051.159765071.davem@davemloft.net>
 <Pine.LNX.4.64.0711151851420.32046@schroedinger.engr.sgi.com>
 <20071115.185854.85318344.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, David Miller wrote:

> > I have not looked at sparc32 sorry. If you simply set up a couple of 
> > configuration values in arch/sparc32/Kconfig then everything will be fine.
> 
> There is assembler code to write, which as I stated several
> times nobody is going to work on or test.

There is no assembly code required. I overdid it in the patch that I sent 
you trying to make sparc64 use large mappings like x86_64 NUMA. You really 
do not need that. Look at the IA64 and i386 configurations. There is no C 
code required. The x86_64 code only adds some special C code for the NUMA 
case.

> > All MMU platforms can use the virtual mappings. The main use of the static 
> > configuration is for embedded systems.
> 
> Someone has to implement and test VMEMMAP now on all of these
> architectures, it is becomming a requirement unlike in the sparsemem
> patches case where it was optional.
> 
> That's unreasonable.

VMEMMAP is something different from the cpu allocator. All MMU platforms 
have vmalloc support and you even suggested the use of vmalloc.
