Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZFVX6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZFVX6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZFVX6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:58:17 -0400
Received: from gate.crashing.org ([63.228.1.57]:49266 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbZFVX6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:58:16 -0400
Subject: Re: [git pull] drm: previous pull req + 1.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Lutomirski <luto@mit.edu>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jerome Glisse <jglisse@redhat.com>,
       Alex Deucher <alexdeucher@gmail.com>
In-Reply-To: <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 09:57:43 +1000
Message-Id: <1245715063.4017.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-06-21 at 12:47 -0700, Linus Torvalds wrote:
> 
> What *has* changed is that we have a newradeon driver, and it looks
> like 
> that new radeon driver is crap, and does this:
> 
>         info->fix.smem_start = (unsigned long)fbptr;
> 
> which is totally screwed up. It assigns a _virtual_ address to that 
> "smem_start" thing, even though it should be a physical one. 

BTW. While we are at it that there's an additional problem (old fbdev
design issue) with that which is smem_start is an unsigned long, which
is too small to hold a physical address on a variety of 32-bit
platforms.

Dave, what about we split those structures into a "sane" in-kernel one
and a "user visible" one ? At that point, we can create new saner
variants of the user ones using separate ioctls ...

> I don't know the radeon driver, so I don't know where to find the
> physical  address.  It's also possible that there is no good single
> physical  address, and the radeon driver should implement a "fb_mmap"
> function.
> 
> Does this patch make the warning and the oops at least go away?
> Obviously  it won't result in a working frame buffer, but that's a
> separate issue

There should be a physical address but it's nasty to let userspace map
it directly without using the DRM for access control, not sure what
David plans here, but it may need surface control set properly etc...

Dave ? Should the fbdev mmap go down the DRM object map path or
similar ?


Cheers,
Ben.

