Return-Path: <linux-kernel-owner+w=401wt.eu-S1754504AbZHONwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504AbZHONwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754279AbZHONwH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:52:07 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:58657 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbZHONwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:52:06 -0400
Date: Sat, 15 Aug 2009 09:49:15 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Jiri Slaby <jirislaby@gmail.com>
cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make shr to divide by power of 2 (resend)
In-Reply-To: <4A86BC96.9040702@gmail.com>
Message-ID: <alpine.LFD.2.00.0908150947260.14440@localhost>
References: <20090815134312.GA7533@localdomain.by> <4A86BC96.9040702@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Jiri Slaby wrote:

> On 08/15/2009 03:43 PM, Sergey Senozhatsky wrote:
> > Make an arithmetic right shift to divide by power of 2.
>
> Why? Is out there a compiler not doing that?
>
> Seems like it should be rather converted to DIV_ROUND_UP.
>
> > Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > ---
> > diff --git a/drivers/video/console/bitblit.c b/drivers/video/console/bitblit.c
> > index 69864b1..b816151 100644
> > --- a/drivers/video/console/bitblit.c
> > +++ b/drivers/video/console/bitblit.c
> > @@ -144,7 +144,7 @@ static void bit_putcs(struct vc_data *vc, struct fb_info *info,
> >  		      int fg, int bg)
> >  {
> >  	struct fb_image image;
> > -	u32 width = (vc->vc_font.width + 7)/8;
> > +	u32 width = (vc->vc_font.width + 7) >> 3;
> >  	u32 cellsize = width * vc->vc_font.height;
> >  	u32 maxcnt = info->pixmap.size/cellsize;
> >  	u32 scan_align = info->pixmap.scan_align - 1;

  it does seem like a DIV_ROUND_UP would be better but perhaps another
solution would be to define a meaningful macro name for that
operation.  if that conversion is going to be done regularly, a macro
with an informative name might be in order.  if it's a one-shot
operation, though, not much point.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
