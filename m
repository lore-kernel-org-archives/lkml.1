Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZGMTvF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZGMTvF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:51:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZGMTvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:51:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32583 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658AbZGMTvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:51:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ua9ATkjE10FHvLAaxpezXIhy8RcLE9/+cfR0a7n46B0VORP7BKQ7VAE2UtaUmmsfQx
         vCfS27X78xL6bQPqZalLHRAY3s+VdEjxAH9PYoc9oixFX3QAHPw+ePP+AuXfQCKITtf2
         /kbY84Fxysa0L26FIylL8Amo8UtN2lKVsKtgc=
Date: Tue, 14 Jul 2009 00:22:51 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <gregkh@suse.de>, fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090713195251.GA1280@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
 <20090713163530.GA22251@suse.de>
 <200907132053.13032.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907132053.13032.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-26)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 13 July 2009, Greg KH wrote:
> > On Mon, Jul 13, 2009 at 07:47:09PM +0430, Ali Gholami Rudi wrote:
> > > Is there any reason for not adding these ioctls to fbdev?  I searched
> > > the net and couldn't any.  Anyway, these patches simply implement those
> > > ioctls.
> > 
> > Have you also added the needed 32 vs. 64 bit handlers for these ioctls?
> > 
> 
> They are not there, but could be trivially added with
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index f8a09bf..ce107c4 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1285,6 +1285,8 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
>  	case FBIOPAN_DISPLAY:
>  	case FBIOGET_CON2FBMAP:
>  	case FBIOPUT_CON2FBMAP:
> +	case FBIOCOPYAREA:
> +	case FBIOFILLRECT:
>  		arg = (unsigned long) compat_ptr(arg);
>  	case FBIOBLANK:
>  		ret = do_fb_ioctl(info, cmd, arg);

Thanks, I'll update the patches.

	Ali
