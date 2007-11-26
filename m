Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbXKZUmo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbXKZUmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 15:42:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754737AbXKZUmg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 15:42:36 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:12244 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864AbXKZUmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 15:42:35 -0500
Date: Mon, 26 Nov 2007 12:40:24 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24-rc3-mm1
Message-Id: <20071126124024.e0170f12.randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<20071126111320.69d0aead.randy.dunlap@oracle.com>
	<Pine.LNX.4.64.0711261127250.23080@schroedinger.engr.sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 11:34:15 -0800 (PST) Christoph Lameter wrote:

> On Mon, 26 Nov 2007, Randy Dunlap wrote:
> 
> > On Tue, 20 Nov 2007 20:45:25 -0800 Andrew Morton wrote:
> > 
> > > 
> > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc3/2.6.24-rc3-mm1/
> > 
> > allnoconfig on x86_64 gives:
> > 
> > arch/x86/mm/init_64.c:84: error: implicit declaration of function 'pfn_valid'
> > mm/page_alloc.c:2533: error: implicit declaration of function 'pfn_valid'
> > mm/vmstat.c:518: error: implicit declaration of function 'pfn_valid'
> > mm/memory.c:400: error: implicit declaration of function 'pfn_valid'
> > drivers/char/mem.c:312: error: implicit declaration of function 'pfn_valid'
> 
> Hmmm... CONFIG_SPARSEMEM is not set if you do allnoconfig
> 
> config SPARSEMEM
>         def_bool y
>         depends on SPARSEMEM_MANUAL
> 
> So I guess we need to set SPARSEMEM_MANUAL
> 
> But arch/x86/Kconfig has
> 
> config SPARSEMEM_MANUAL
>         bool "Sparse Memory"
>         depends on ARCH_SPARSEMEM_ENABLE
>         help
>           This will be the only option for some systems, including
>           memory hotplug systems.  This is normal.
> 
> It needs to be not deselectable for x86_64. 
> 
> Inserting
> 
> 	def_bool y if X86_64
> 
> did not help....
> 
> Somehow make menuconfig did not give me an ability to even enable this 
> again.

Thanks for the hint.

ARCH_SELECT_MEMORY_MODEL depends on X86_32.  Is that too restrictive?

config ARCH_SELECT_MEMORY_MODEL
	def_bool y
	depends on X86_32 && ARCH_SPARSEMEM_ENABLE

---
~Randy
