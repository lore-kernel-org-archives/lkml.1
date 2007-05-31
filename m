Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbXEaML4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbXEaML4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 08:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759959AbXEaMLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 08:11:50 -0400
Received: from ns1.suse.de ([195.135.220.2]:34022 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759904AbXEaMLt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 08:11:49 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Dave Airlie" <airlied@gmail.com>
Subject: Re: GFP_DMA32 and PAE x86 machines
Date: Thu, 31 May 2007 14:11:39 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Linus Torvalds" <torvalds@osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
References: <21d7e9970705301410m16ded9esdf7a49371c60a155@mail.gmail.com> <200705310024.25937.ak@suse.de> <21d7e9970705301609w88a9f80t20f83806003f699e@mail.gmail.com>
In-Reply-To: <21d7e9970705301609w88a9f80t20f83806003f699e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705311411.39764.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Funnily enough I have just today with an app I have which uses 1.2GB
> of textures :-)

Realistic app which is something users really run?
Also do the other constraints above apply?

If you use pci_alloc_coherent() then it will already take care of the rules
above btw (e.g. DTRT when the machine has <3GB etc.) 

> we are currently using GFP_DMA32 in the TTM allocator code, however
> what I really want on x86 non-PAE is GFP_HIGHMEM (as DMA32 does
> nothing) however on x86-PAE I don't want that I want a real GFP_DMA32,
> and on x86-64 I want the current GFP_DMA32,

You should be probably using pci_alloc_coherent() at least on x86.
It might get more expensive on some obscure platforms (which DRM
likely doesn't support anyways), but if it does perhaps a pci_alloc_noncoherent()
or so would be useful (on x86 it would be the same) 

-Andi
