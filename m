Return-Path: <linux-kernel-owner+w=401wt.eu-S933365AbXHLKLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933365AbXHLKLr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 06:11:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbXHLKLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 06:11:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:49474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756742AbXHLKLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 06:11:36 -0400
From: Andi Kleen <ak@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] [1/12] x86: Work around mmio config space quirk on AMD Fam10h
Date: Sun, 12 Aug 2007 12:03:23 +0200
User-Agent: KMail/1.9.1
Cc: dean@arctic.org, patches@x86-64.org, linux-kernel@vger.kernel.org
References: <20070809241.425881000@suse.de> <20070809124128.886BE14F3B@wotan.suse.de> <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0708120216470.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708121203.23741.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 12 August 2007 11:25, Linus Torvalds wrote:
> On Thu, 9 Aug 2007, Andi Kleen wrote:
> > Some broken devices have been discovered to require %al/%ax/%eax
> > registers for MMIO config space accesses.  Modify mmconfig.c to use these
> > registers explicitly (rather than modify the global readb/writeb/etc
> > inlines).
> >
> > AK: also changed i386 to always use eax
> > AK: moved change to extended space probing to different patch
> > AK: reworked with inlines according to Linus' requirements.
> > AK: improve comments.
> >
> > Signed-off-by: dean gaudet <dean@arctic.org>
> > Signed-off-by: Andi Kleen <ak@suse.de>
>
> Damn you, Andi.

Thanks for the kind words.

> You had obviously never actually tested this on x86.

Hmm, it booted on my i386 test box but it's possible it didn't use MCFG.

>
> > --- linux.orig/arch/i386/pci/mmconfig.c
> > +++ linux/arch/i386/pci/mmconfig.c
> > -		writeb(value, mmcfg_virt_addr + reg);
> > +		mmio_config_writeb(mmcfg_virt_addr, value);
>
> Notice something missing here? The new code cannot work on any machine
> that actually uses mmio cfg.

Sigh. Ok I assume you already reverted and I'll send a new one.

-Andi
