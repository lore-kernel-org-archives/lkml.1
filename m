Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbZBIVv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbZBIVv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZBIVvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:51:36 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42974 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbZBIVvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:51:35 -0500
Date: Mon, 9 Feb 2009 16:51:31 -0500
From: Andres Salomon <dilinger@queued.net>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 14/15] amifb: check fb_alloc_cmap
 return value and handle failure properly
Message-ID: <20090209165131.4c625d4c@ephemeral>
In-Reply-To: <20090209212629.611bd99d.krzysztof.h1@wp.pl>
References: <20090207121857.6bc5d5bc@ephemeral>
	<20090209212629.611bd99d.krzysztof.h1@wp.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 21:26:29 +0100
Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> On Sat, 7 Feb 2009 12:18:57 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > ---
> 
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> One comment below.
[...]
> > @@ -2456,7 +2458,8 @@ amifb_error:
> >  
> >  static void amifb_deinit(void)
> >  {
> > -	fb_dealloc_cmap(&fb_info.cmap);
> > +	if (fb_info.cmap.len)
> > +		fb_dealloc_cmap(&fb_info.cmap);
> 
> Again, is the "if(fb_info.cmap.len)" needed here?

Yep; amifb_deinit is called from amifb_init in the case of errors.
This can happen before fb_alloc_cmap is called (but after the memory
region has been requested), so we need to explicitly check that cmap
memory has been allocated.


