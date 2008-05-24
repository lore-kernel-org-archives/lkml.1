Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbYEXTiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbYEXTiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 15:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbYEXTij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 15:38:39 -0400
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1839 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbYEXTii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 15:38:38 -0400
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
From: Miquel van Smoorenburg <miquels@cistron.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, andi-suse@firstfloor.org
In-Reply-To: <1211484343.30678.15.camel@localhost.localdomain>
References: <20080521113028.GA24632@xs4all.net>
	 <48341A57.1030505@redhat.com>  <20080522084736.GC31727@one.firstfloor.org>
	 <1211484343.30678.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 May 2008 21:38:18 +0200
Message-Id: <1211657898.25661.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 21:25 +0200, Miquel van Smoorenburg wrote:
> Most drivers call pci_alloc_consistent() which calls
> dma_alloc_coherent(.... GFP_ATOMIC) which can dip deep into reserves so
> it won't fail so easily. Just a handful use dma_alloc_coherent()
> directly.
> 
> However, in 2.6.26-rc1, dpt_i2o.c was updated for 64 bit support, and
> all it's kmalloc(.... GFP_KERNEL) + virt_to_bus() calls have been
> replaced by dma_alloc_coherent(.... GFP_KERNEL).
> 
> In that case, it's not a very good idea to add __GFP_NORETRY.
>
> I think we should do something. How about one of these two patches.

And Andi wrote:

On Fri, 2008-05-23 at 00:59 +0200, Andi Kleen wrote:
> Anyways the reasoning is still valid. Longer term the mask allocator
> would be the right fix, shorter term a new GFP flag as proposed 
> sounds reasonable.

So how about linux-2.6.26-gfp-no-oom.patch (see previous mail) for
2.6.26 ?

Mike.

