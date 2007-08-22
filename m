Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbXHVVqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbXHVVqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932866AbXHVVpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:45:38 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:44060 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932898AbXHVVpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:45:36 -0400
Date: Wed, 22 Aug 2007 23:44:35 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc3-mm1: inlining failures in sound/pci/hda/hda_codec.c
Message-ID: <20070822214435.GK30705@stusta.de>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222223.04610.m.kozlowski@tuxland.pl> <s5h6437nuqy.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <s5h6437nuqy.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:07:33PM +0200, Takashi Iwai wrote:
> At Wed, 22 Aug 2007 22:23:03 +0200,
> Mariusz Kozlowski wrote:
> > 
> > Hello,
> > 
> > 	This is from x86_32 with gcc 3.4.6:
> > 
> >   CC [M]  sound/pci/hda/hda_codec.o
> > sound/pci/hda/hda_codec.c: In function `snd_hda_codec_free':
> > sound/pci/hda/hda_codec.c:517: sorry, unimplemented: inlining failed in call to 'free_hda_cache': function body not available
> > sound/pci/hda/hda_codec.c:534: sorry, unimplemented: called from here
> > sound/pci/hda/hda_codec.c:517: sorry, unimplemented: inlining failed in call to 'free_hda_cache': function body not available
> > sound/pci/hda/hda_codec.c:535: sorry, unimplemented: called from here
> > make[3]: *** [sound/pci/hda/hda_codec.o] Error 1
> > make[2]: *** [sound/pci/hda] Error 2
> > make[1]: *** [sound/pci] Error 2
> > make: *** [sound] Error 2
> 
> Since it doesn't happen with gcc-4.x, this looks like a gcc-3.x
> specific problem.
>...

It happens because gcc doesn't see the whole file without 
unit-at-a-time and we disable unit-at-a-time with gcc 3.4 on i386 due 
to stack usage problems (and older GNU gcc versions don't support 
unit-at-a-time at all).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

