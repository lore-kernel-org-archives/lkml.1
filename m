Return-Path: <linux-kernel-owner+w=401wt.eu-S1756743AbZGMUGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743AbZGMUGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756806AbZGMUGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:06:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:6272 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbZGMUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:06:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vowx2g1C5ewWj6+fVPV2opO+4ijQh37gQa3SpXrvSEXQ+Z8j6WyXR2JO4fP2yWKXiO
         KpSJJ5l9yVgO7EZ5s9H77FTjhqGE9Gaxk4kPHeSp2E7Kw5LcdVSllEobdKmm1kvTaUWd
         OG8CW1kfyQ/7Qdt0HRmkbkcSilDh4HddHvO7I=
Date: Tue, 14 Jul 2009 00:38:04 +0430
From: Ali Gholami Rudi <ali@rudi.ir>
To: Greg KH <gregkh@suse.de>
Cc: fbdev <linux-fbdev-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Righi <righi.andrea@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Philippe De Muyter <phdm@macqel.be>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fbdev: add fillrect and copyarea ioctls
Message-ID: <20090713200804.GB1280@lilem.mirepesht>
References: <20090713151709.GA1297@lilem.mirepesht>
 <20090713163530.GA22251@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713163530.GA22251@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-26)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> wrote:
> On Mon, Jul 13, 2009 at 07:47:09PM +0430, Ali Gholami Rudi wrote:
> > Is there any reason for not adding these ioctls to fbdev?  I searched
> > the net and couldn't any.  Anyway, these patches simply implement those
> > ioctls.
> 
> Have you also added the needed 32 vs. 64 bit handlers for these ioctls?

I guess Arnd's patch will do.

By the way, it should check for overflows, too?  I mean should I change
this:

> +       if (copy->dx + copy->width > info->var.xres ||
> +           copy->sx + copy->width > info->var.xres ||
> +           copy->dy + copy->height > info->var.yres ||
> +           copy->sy + copy->height > info->var.yres) {

#define ISSUMLESSTHAN(a, b, s)	(((a) <= (s)) && ((b) <= (s)) && \
				 ((a) + (b) <= (s)))

if (!ISSUMLESSTHAN(copy->dx, copy->width, info->var.xres) || ...

	Ali
