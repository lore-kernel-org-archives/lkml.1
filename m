Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbZIPU1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbZIPU1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 16:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759959AbZIPU0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 16:26:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:37069 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759952AbZIPU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 16:26:55 -0400
Date: Wed, 16 Sep 2009 22:26:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Bryan Wu <cooloney@kernel.org>, uclinux-dist-devel@blackfin.uclinux.org
Subject: Re: [PATCH] blackfin: Cleanup linker script using new linker
	script macros.
Message-ID: <20090916202655.GA17153@merkur.ravnborg.org>
References: <1252292753-11792-1-git-send-email-tabbott@ksplice.com> <8bd0f97a0909152013oe652087gf5cd227a1997a5b3@mail.gmail.com> <alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0909160107500.19188@dr-wily.mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 11:58:01AM -0400, Tim Abbott wrote:
> On Tue, 15 Sep 2009, Mike Frysinger wrote:
> 
> > the larger padding in the initramfs is kind of annoying as i cant see
> > any need to pad it to PAGE_SIZE.  since the initramfs is released with
> > the rest of the init section, it doesnt need whole pages.  a quick
> > test shows that it does waste a few kb in reality.  default build for
> > BF533-STAMP for example shows 0x1000 difference.
> > 
> > in terms of correctness, this change misses a reference to the now
> > deleted .init.ramfs:
> > -       .init.ramfs :
> > -       {
> > -       .....
> > -       }
> > -
> >        .text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))
> > 
> > so that .text_l1 needs to updated to refer to the new section before
> > it (.exit.data in this case).  once i make that change, the resulting
> > link looks the same (minus the initramfs thing mentioned earlier), and
> > it does boot.
> 
> OK.  I guess we should plan to modify the INIT_DATA_SECTION macro to add 
> another argument specifying an alignment level for .init.ramfs.  It'd be 
> inconvenient to add that right now since there are a lot of patches in 
> linux-next or otherwise in flight that introduce uses of 
> INIT_DATA_SECTION, and those patches would all be broken by changing this 
> now.  Once the dust settles on that for this release, I'll submit a patch 
> adding said argument to INIT_DATA_SECTION.

But this is all discarded during runtime so the added alignment has no cost in the end - no?

	Sam
