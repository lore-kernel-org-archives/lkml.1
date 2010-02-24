Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab0BXTVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 14:21:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:22239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757579Ab0BXTVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:21:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=wsKqUvJ5j5A2+vtv9dudrMF9W6/3/O4KXuFlLO1S+dVwNcQVo2zHQBREfko0b/FO4A
         p01zrmv5say75/mb1KOdZHoCCpMdRHteklegcSWk0WSM49EMsa1z4pX8p1Ab2ZUtzDgH
         6Mod+e/GUiRDNAhb2Sg2zE/mDh01rMph5gXB4=
Date: Wed, 24 Feb 2010 11:21:26 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/14] Regulators: wm8400 - cleanup platform driver data
 handling
Message-ID: <20100224192126.GE25304@core.coreip.homeip.net>
References: <20100224073342.15964.8863.stgit@localhost.localdomain>
 <20100224073849.15964.62321.stgit@localhost.localdomain>
 <20100224102548.GG18896@rakim.wolfsonmicro.main>
 <20100224190234.GD25304@core.coreip.homeip.net>
 <20100224191402.GA8316@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100224191402.GA8316@rakim.wolfsonmicro.main>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 07:14:03PM +0000, Mark Brown wrote:
> On Wed, Feb 24, 2010 at 11:02:34AM -0800, Dmitry Torokhov wrote:
> > On Wed, Feb 24, 2010 at 10:25:49AM +0000, Mark Brown wrote:
> 
> > > Nack due to this change - this change would make it impossible for
> > > callers to actually call the function.  Note that nothing including only
> > > wm8400.h even has a struct declaration, much less defniition, for struct
> > > wm8400.
> 
> > If you notice I added forward declaration of "struct wm8400" to wm8400.h
> > thus users can pass around pointer to the structure.
> 
> This doesn't help unless you also provide a way for users to obtain a
> struct wm8400.

Why would they need it? Only code that creates instances of wm8400 needs
to know the definition of the sturcture, the rest can simply pass the
pointer around.

I guess there is disconnect between us and I do not see any users of
wm8400_register_regulator() in linux-next... Is there another tree I
could peek at?

> 
> > I really think we should refrain from passing naked 'struct device *'
> > pointers as much as possible since it is error prone. Otherwise
> > wm8400_register_regulator has no way of ensuting that passed  'dev' is
> > indeed wm8400.
> 
> Right, there's no type safety here (and this whole method of registering
> regulators is fairly deprecated anyway in favour of just straight
> platform data) but really it doesn't buy us much - the users get exactly
> the struct device they need to use passed in to them, there's really
> very little chance for them to get confused about what they're talking
> about.

-- 
Dmitry
