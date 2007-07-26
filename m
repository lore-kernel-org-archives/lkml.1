Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbXGZM53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbXGZM53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 08:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbXGZM5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 08:57:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:49283 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbXGZM5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 08:57:19 -0400
Date: Thu, 26 Jul 2007 14:58:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       sparclinux@vger.kernel.org
Subject: Re: ALSA & missing dma_*_coherent on sparc32
Message-ID: <20070726125834.GA4041@uranus.ravnborg.org>
References: <Pine.SOC.4.64.0707261317001.20971@math.ut.ee> <s5h7ionv0xc.wl%tiwai@suse.de> <Pine.SOC.4.64.0707261501130.24473@math.ut.ee> <s5h6447uzrk.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h6447uzrk.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 02:15:43PM +0200, Takashi Iwai wrote:
> At Thu, 26 Jul 2007 15:02:51 +0300 (EEST),
> Meelis Roos wrote:
> > 
> > > > ERROR: "dma_free_coherent" [sound/core/snd-page-alloc.ko] undefined!
> > > > ERROR: "dma_alloc_coherent" [sound/core/snd-page-alloc.ko] undefined!
> > > 
> > > Could you show .config?  Does it have CONFIG_HAS_DMA?
> > 
> > No, CONFIG_NO_DMA=y - and this was recently changed on sparc32 IIRC.
> 
> OK, then could you try the patch below?

Hi Takashi-san.

Can I ask you to introdue use of the -y syntax for composite objects.
This would simplify soucd/core/Makefile

The below would then become:
>  
> -snd-page-alloc-objs := memalloc.o sgbuf.o
> +snd-page-alloc-y := memalloc.o
> +snd-page-alloc-$(CONFIG_HAS_DMA) += sgbuf.o
>  
>  snd-rawmidi-objs  := rawmidi.o
>  snd-timer-objs    := timer.o

Ask if you have questions.

Thanks,
	Sam
