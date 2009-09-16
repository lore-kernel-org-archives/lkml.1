Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZIPP74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZIPP74 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:59:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbZIPP74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:59:56 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:47931 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753644AbZIPP7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:59:55 -0400
Date: Wed, 16 Sep 2009 11:58:01 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: Mike Frysinger <vapier.adi@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Bryan Wu <cooloney@kernel.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker script
 	macros.
In-Reply-To: <8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com> <8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009, Mike Frysinger wrote:

> the larger padding in the initramfs is kind of annoying as i cant see
> any need to pad it to PAGE_SIZE.  since the initramfs is released with
> the rest of the init section, it doesnt need whole pages.  a quick
> test shows that it does waste a few kb in reality.  default build for
> BF533-STAMP for example shows 0x1000 difference.
> 
> in terms of correctness, this change misses a reference to the now
> deleted .init.ramfs:
> -       .init.ramfs :
> -       {
> -       .....
> -       }
> -
>        .text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))
> 
> so that .text_l1 needs to updated to refer to the new section before
> it (.exit.data in this case).  once i make that change, the resulting
> link looks the same (minus the initramfs thing mentioned earlier), and
> it does boot.

OK.  I guess we should plan to modify the INIT_DATA_SECTION macro to add 
another argument specifying an alignment level for .init.ramfs.  It'd be 
inconvenient to add that right now since there are a lot of patches in 
linux-next or otherwise in flight that introduce uses of 
INIT_DATA_SECTION, and those patches would all be broken by changing this 
now.  Once the dust settles on that for this release, I'll submit a patch 
adding said argument to INIT_DATA_SECTION.

	-Tim Abbott
