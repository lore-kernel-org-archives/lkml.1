Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbXKZTed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbXKZTed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXKZTeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:34:23 -0500
Received: from relay1.sgi.com ([192.48.171.29]:45043 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755574AbXKZTeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:34:22 -0500
Date: Mon, 26 Nov 2007 11:34:15 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
In-Reply-To: <20071126111320.69d0aead.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
 <20071126111320.69d0aead.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007, Randy Dunlap wrote:

> On Tue, 20 Nov 2007 20:45:25 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
> 
> allnoconfig on x86_64 gives:
> 
> arch/x86/mm/init_64.c:84: error: implicit declaration of function 'pfn_valid'
> mm/page_alloc.c:2533: error: implicit declaration of function 'pfn_valid'
> mm/vmstat.c:518: error: implicit declaration of function 'pfn_valid'
> mm/memory.c:400: error: implicit declaration of function 'pfn_valid'
> drivers/char/mem.c:312: error: implicit declaration of function 'pfn_valid'

Hmmm... CONFIG_SPARSEMEM is not set if you do allnoconfig

config SPARSEMEM
        def_bool y
        depends on SPARSEMEM_MANUAL

So I guess we need to set SPARSEMEM_MANUAL

But arch/x86/Kconfig has

config SPARSEMEM_MANUAL
        bool "Sparse Memory"
        depends on ARCH_SPARSEMEM_ENABLE
        help
          This will be the only option for some systems, including
          memory hotplug systems.  This is normal.

It needs to be not deselectable for x86_64. 

Inserting

	def_bool y if X86_64

did not help....

Somehow make menuconfig did not give me an ability to even enable this 
again.

