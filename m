Return-Path: <linux-kernel-owner+w=401wt.eu-S1762076AbYFKPja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762076AbYFKPja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 11:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761921AbYFKPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 11:39:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761913AbYFKPjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 11:39:14 -0400
Date: Wed, 11 Jun 2008 11:39:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Bernhard Walle <bwalle@suse.de>
Subject: Re: [PATCH] Limit E820 map and /proc/iomem for mem parameter on
	x86-64
Message-ID: <20080611153901.GD6450@redhat.com>
References: <20080610215325.GA20673@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080610215325.GA20673@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:53:25PM +0200, Bernhard Walle wrote:
> This patch tries to unify the behaviour of i386 and x86-64 when parsing
> the memory (mem/memmap) parameter of the kernel command line:
> 
> On i386, the view was limited (i.e. the actual view was presented).
> On x86-64, the view was full (i.e. the BIOS view was presented).
> 
> This patch moves the limit_regions() function and the print_memory_map()
> function to a new file e820.c, shared between the two x86 flavours. Then
> it adds calls to limit_regions() in 64 bit code.
> 
> I gave the patch a bit testing. However, it's not for merging, it's just
> to get early feedback to see if that goes into the right direction.
> 
> 

I would like to have consistent behavior of /proc/iomem across i386
and x86_64, so this sounds like right direction to me.

Also I would like to have another interface (say /proc/iomem_kernel)which
actually gets modified based on the user specified options. So effectively we
can have both the views. BIOS view and user defined view.

As discussed on kexec mailing list, it helps kexec and kdump operation. 
In the case of kexec, we want to know the actual resources present in 
the system so that new kernel can see it (Irrespective of the fact
what first kernel was actually using).

In case of kdump, we want to see truncated view so that we don't end
up capturing the contents of memory not being used by kernel.

Thanks
Vivek
