Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbZBIVzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbZBIVzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 16:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbZBIVzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 16:55:44 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57499 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbZBIVzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 16:55:44 -0500
Date: Mon, 9 Feb 2009 16:55:40 -0500
From: Andres Salomon <dilinger@queued.net>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       adaplas@gmail.com
Subject: Re: [Linux-fbdev-devel] [PATCH 13/15] amba-clcd: fix cmap memory
 leaks
Message-ID: <20090209165540.523c2ce4@ephemeral>
In-Reply-To: <20090209211614.44459a12.krzysztof.h1@wp.pl>
References: <20090207121848.536b136d@ephemeral>
	<20090209211614.44459a12.krzysztof.h1@wp.pl>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 21:16:14 +0100
Krzysztof Helt <krzysztof.h1@wp.pl> wrote:

> On Sat, 7 Feb 2009 12:18:48 -0500
> Andres Salomon <dilinger@queued.net> wrote:
> 
> > 
> >  - fix cmap leak in removal path
> >  - fix cmap leak when register_framebuffer fails
> > 
> > Signed-off-by: Andres Salomon <dilinger@debian.org>
> > ---
> 
> Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> 
> One comment (see below).
> 
[...]
> > @@ -485,6 +489,8 @@ static int clcdfb_remove(struct amba_device
> > *dev) 
> >  	clcdfb_disable(fb);
> >  	unregister_framebuffer(&fb->fb);
> > +	if (fb->fb.cmap.len)
> > +		fb_dealloc_cmap(&fb->fb.cmap);
> 
> Is this if() needed? Is this function called twice (or more) or
> can it be called without the cmap allocated?


It was added as a precaution due to the fb->board->remove callbacks,
but I think I misunderstood the code.  So my official answer is "I'm not
sure." :)





> 
> >  	iounmap(fb->regs);
> >  	clk_put(fb->clk);
> >  
> > -- 
> > 1.5.6.5
> > 
