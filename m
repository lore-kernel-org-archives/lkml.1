Return-Path: <linux-kernel-owner+w=401wt.eu-S932474AbZABXAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbZABXAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 18:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbZABXAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 18:00:39 -0500
Received: from pfepb.post.tele.dk ([195.41.46.236]:38835 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbZABXAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 18:00:38 -0500
Date: Sat, 3 Jan 2009 00:02:15 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Eric Anholt <eric@anholt.net>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.28-git3 and i915 Kconfig new dependency on framebuffer
Message-ID: <20090102230215.GA9184@uranus.ravnborg.org>
References: <5a4c581d0812311055m5f9f395ci331457f9ed1d1a7f@mail.gmail.com> <1230936608.6095.2.camel@gaiman.anholt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230936608.6095.2.camel@gaiman.anholt.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 02:50:08PM -0800, Eric Anholt wrote:
> On Wed, 2008-12-31 at 19:55 +0100, Alessandro Suardi wrote:
> > make oldconfig from -git2 to -git3 doesn't build i915.ko unless
> >  one has CONFIG_FB enabled; this causes /dev/dri/card0 to
> >  be missing, and DRI disabled from within X.
> > 
> > Do I now (2.6.28-git3+) need CONFIG_FB to enable i915 DRM ?
> 
> Yes, the i915 driver now relies on fb code, though the new features are
> runtime optional.  I may have noviced the Kconfig bits -- my intention
> was "If you select I915, you also get all the CONFIG_FB-related bits
> necessary".
> 
> config DRM_I915
>         select FB_CFB_FILLRECT
>         select FB_CFB_COPYAREA
>         select FB_CFB_IMAGEBLIT
>         depends on FB
>         tristate "i915 driver"
> 
> I'm guessing that that "depends on FB" wants to be "select FB".

No - that would not fly...
You somehow need to educate the people that want to enable DRM_I915 that
they cannot do so before they enable framebuffer support.

When you consider using select on a symbol that has a prompt
you have a good sign that you do something wrong.

	Sam
