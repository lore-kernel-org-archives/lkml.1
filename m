Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbXEII56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbXEII56 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755962AbXEII5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:57:04 -0400
Received: from m-relay.rz.uni-saarland.de ([134.96.7.3]:55525 "EHLO
	m-relay.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755751AbXEII5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:57:01 -0400
Date: Wed, 9 May 2007 10:54:34 +0200
From: Alexander van Heukelum <heukelum@mailshack.com>
To: "Antonino A. Daplas" <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make bootsector stub 16-bit-only (i386)
Message-ID: <20070509085434.GA13712@mailshack.com>
References: <20070505104452.GA30944@mailshack.com> <20070508032817.e4734798.akpm@linux-foundation.org> <20070508183232.GA13225@mailshack.com> <1178669047.4747.15.camel@daplas>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178669047.4747.15.camel@daplas>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.5.1 (m-relay.rz.uni-saarland.de [134.96.7.3]); Wed, 09 May 2007 10:55:58 +0200 (CEST)
X-AntiVirus: checked by AntiVir Milter (version: 1.1.3-1; AVE: 7.3.1.53; VDF: 6.38.1.19; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 08:04:07AM +0800, Antonino A. Daplas wrote:
> On Tue, 2007-05-08 at 20:32 +0200, Alexander van Heukelum wrote:
> > diff --git a/arch/i386/boot/bootsect.S b/arch/i386/boot/bootsect.S
> > diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> > index 8143c95..8e404cb 100644
> > --- a/arch/i386/boot/video.S
> > +++ b/arch/i386/boot/video.S
> > @@ -95,7 +95,8 @@ #define PARAM_VESAPM_SEG	0x2e
> >  #define PARAM_VESAPM_OFF	0x30
> >  #define PARAM_LFB_PAGES		0x32
> >  #define PARAM_VESA_ATTRIB	0x34
> > -#define PARAM_CAPABILITIES	0x36
> > +#define PARAM_VESA_PAD		0x36
> > +#define PARAM_CAPABILITIES	0x38
> >  
> >  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
> >  #ifdef CONFIG_VIDEO_RETAIN
> > diff --git a/include/linux/screen_info.h b/include/linux/screen_info.h
> > index b02308e..0a2e892 100644
> > --- a/include/linux/screen_info.h
> > +++ b/include/linux/screen_info.h
> > @@ -41,8 +41,8 @@ struct screen_info {
> >  	u16 vesapm_off;		/* 0x30 */
> >  	u16 pages;		/* 0x32 */
> >  	u16 vesa_attributes;	/* 0x34 */
> > -	u32 capabilities;       /* 0x36 */
> > -				/* 0x3a -- 0x3b reserved for future expansion */
> > +	u16 vesa_pad;		/* 0x36 */
> > +	u32 capabilities;       /* 0x38 */
> >  				/* 0x3c -- 0x3f micro stack for relocatable kernels */
> >  };
> >  
> 
> You would also need this minor change.
> 
> Tony
> 
> diff --git a/arch/i386/boot/video.S b/arch/i386/boot/video.S
> index 5e2280c..2d637d1 100644
> --- a/arch/i386/boot/video.S
> +++ b/arch/i386/boot/video.S
> @@ -95,7 +95,7 @@ #define PARAM_VESAPM_SEG      0x2e
>  #define PARAM_VESAPM_OFF       0x30
>  #define PARAM_LFB_PAGES                0x32
>  #define PARAM_VESA_ATTRIB      0x34
> -#define PARAM_CAPABILITIES     0x36
> +#define PARAM_CAPABILITIES     0x38
>  
>  /* Define DO_STORE according to CONFIG_VIDEO_RETAIN */
>  #ifdef CONFIG_VIDEO_RETAIN

Hi!

I'm making coffee now. I just don't see what I missed? Maybe you were
led astray by the new PARAM_VESA_PAD I added?

Greetings,
	Alexander
