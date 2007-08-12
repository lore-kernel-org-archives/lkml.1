Return-Path: <linux-kernel-owner+w=401wt.eu-S933810AbXHLJZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933810AbXHLJZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 05:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbXHLJZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 05:25:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43914 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759594AbXHLJZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 05:25:34 -0400
Date: Sun, 12 Aug 2007 02:25:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <ak@suse.de>
cc: dean@arctic.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD
 Fam10h
In-Reply-To: <20070809124128.886BE14F3B@wotan.suse.de>
Message-ID: <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org>
References: <20070809241.425881000@suse.de>
 <20070809124128.886BE14F3B@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Aug 2007, Andi Kleen wrote:
>
> Some broken devices have been discovered to require %al/%ax/%eax registers 
> for MMIO config space accesses.  Modify mmconfig.c to use these registers 
> explicitly (rather than modify the global readb/writeb/etc inlines).
> 
> AK: also changed i386 to always use eax
> AK: moved change to extended space probing to different patch
> AK: reworked with inlines according to Linus' requirements.
> AK: improve comments.
> 
> Signed-off-by: dean gaudet <dean@arctic.org>
> Signed-off-by: Andi Kleen <ak@suse.de>

Damn you, Andi.

You had obviously never actually tested this on x86.

> --- linux.orig/arch/i386/pci/mmconfig.c
> +++ linux/arch/i386/pci/mmconfig.c
> -		writeb(value, mmcfg_virt_addr + reg);
> +		mmio_config_writeb(mmcfg_virt_addr, value);

Notice something missing here? The new code cannot work on any machine 
that actually uses mmio cfg.

		Linus
