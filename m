Return-Path: <linux-kernel-owner+w=401wt.eu-S933254AbXGWTCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933254AbXGWTCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761855AbXGWTB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:01:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:11678 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbXGWTB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:01:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=gqacul5CeABJKuJZmIKChmG0WwN4hI6r//F0yOFzsVcehqwXjVxsmIhXKRlUj2VNIb0AhNB2TPjq/ZnD/cMMdRhKcx3hQF3GHB7N7qATOTbVLxhta8jZ8Kx//xlOCdTL9qIns3PXjHfzcFc+2WJmDhQnmhs/J8x/99ru4eL4gqw=
Date: Mon, 23 Jul 2007 23:01:52 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org
Subject: Re: 2.6.23-rc1: BUG_ON in kmap_atomic_prot()
Message-ID: <20070723190152.GA5755@martell.zuzino.mipt.ru>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070723183839.GA5874@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070723183839.GA5874@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 10:38:39PM +0400, Alexey Dobriyan wrote:
> Managed to hit BUG_ON() in kmap_atomic_prot() three times while doing
> nothing unusual for this box (two times it was under X, so I can't
> guarantee, one time while trying to reproduce via ./configure in gdb
> tarball)
> 
> Box has 2.5G of RAM. 2.6.22 was OK.
> 
> [dives into framebuffer console setup for complete oops]

kernel BUG at arch/i386/mm/highmem.c:38
PREEMPT DEBUG_PAGEALLOC SLAB
EIP at kmap_atomic_prot+0x32/0x93
	get_page_from_freelist
	__alloc_pages
	cache_alloc_refill
	cache_alloc_refill
	kmem_cache_alloc
	dst_alloc
	dst_alloc
	__ip_route_output_key
	[some junk I don't trust]

eax: 0000000c
ebx: 00000003
ecx: c065efe0
edx: 00000003
edi: 00000163


c010cc9b <kmap_atomic_prot>:
c010cc9b:	57                   	push   %edi
c010cc9c:	56                   	push   %esi
c010cc9d:	53                   	push   %ebx
c010cc9e:	89 c6                	mov    %eax,%esi
c010cca0:	89 d3                	mov    %edx,%ebx
c010cca2:	89 cf                	mov    %ecx,%edi
c010cca4:	b8 01 00 00 00       	mov    $0x1,%eax
c010cca9:	e8 dd 1b 00 00       	call   c010e88b <add_preempt_count>
c010ccae:	e8 b1 ac 0e 00       	call   c01f7964 <debug_smp_processor_id>
c010ccb3:	6b c0 0d             	imul   $0xd,%eax,%eax
c010ccb6:	8d 14 03             	lea    (%ebx,%eax,1),%edx
c010ccb9:	8d 04 95 00 00 00 00 	lea    0x0(,%edx,4),%eax
c010ccc0:	8b 0d 30 a1 3e c0    	mov    0xc03ea130,%ecx
c010ccc6:	29 c1                	sub    %eax,%ecx
c010ccc8:	83 39 00             	cmpl   $0x0,(%ecx)
c010cccb:	74 04                	je     c010ccd1 <kmap_atomic_prot+0x36>
c010cccd:	0f 0b                	ud2a   

