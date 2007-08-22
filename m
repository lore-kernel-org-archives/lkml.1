Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXHVVTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXHVVTG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 17:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933902AbXHVVSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 17:18:45 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3700 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933839AbXHVVSn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 17:18:43 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: 2.6.23-rc3-mm1: inlining failures in sound/pci/hda/hda_codec.c
Date: Wed, 22 Aug 2007 23:18:37 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <200708222223.04610.m.kozlowski@tuxland.pl> <s5h6437nuqy.wl%tiwai@suse.de>
In-Reply-To: <s5h6437nuqy.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708222318.38607.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

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
> specific problem.   Does the patch below fix?

Yes - it does.

Thanks,

	Mariusz
 
> diff -r db9001b20d29 pci/hda/hda_codec.c
> --- a/pci/hda/hda_codec.c	Wed Aug 22 14:19:45 2007 +0200
> +++ b/pci/hda/hda_codec.c	Wed Aug 22 23:06:00 2007 +0200
> @@ -514,7 +514,7 @@ static int read_widget_caps(struct hda_c
>  
>  static void init_hda_cache(struct hda_cache_rec *cache,
>  			   unsigned int record_size);
> -static inline void free_hda_cache(struct hda_cache_rec *cache);
> +static void free_hda_cache(struct hda_cache_rec *cache);
>  
>  /*
>   * codec destructor
> @@ -707,7 +707,7 @@ static void __devinit init_hda_cache(str
>  	cache->record_size = record_size;
>  }
>  
> -static inline void free_hda_cache(struct hda_cache_rec *cache)
> +static void free_hda_cache(struct hda_cache_rec *cache)
>  {
>  	kfree(cache->buffer);
>  }
> -
