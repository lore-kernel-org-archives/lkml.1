Return-Path: <linux-kernel-owner+w=401wt.eu-S1755844AbYEYVP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844AbYEYVP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 17:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYEYVPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 17:15:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45483 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYEYVPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 17:15:17 -0400
Date: Sun, 25 May 2008 23:23:50 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
       Miquel van Smoorenburg <miquels@cistron.nl>,
       Glauber Costa <gcosta@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, andi-suse@firstfloor.org
Subject: Re: 2.6.26: x86/kernel/pci_dma.c: gfp |= __GFP_NORETRY ?
Message-ID: <20080525212350.GB8405@one.firstfloor.org>
References: <20080521113028.GA24632@xs4all.net> <48341A57.1030505@redhat.com> <20080522084736.GC31727@one.firstfloor.org> <1211484343.30678.15.camel@localhost.localdomain> <1211657898.25661.2.camel@localhost.localdomain> <20080525163539.GA8405@one.firstfloor.org> <20080525205532.3ed5e478@core>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525205532.3ed5e478@core>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 08:55:32PM +0100, Alan Cox wrote:
> On Sun, 25 May 2008 18:35:39 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > So how about linux-2.6.26-gfp-no-oom.patch (see previous mail) for
> > > 2.6.26 
> > 
> > Changing the gfp once globally like you did is not right, because
> > the different fallback cases have to be handled differently
> > (see the different cases I discussed in my earlier mail)
> > 
> > Especially the 16MB zone allocation should never trigger the OOM killer.
> 
> That depends how much memory you have.

No it doesn't because the lower zone protection basically never puts
anything that is not GFP_DMA into the 16MB zone.

Just check yourself on your machine using sysrq.

That was one of the motivations behind the mask allocator design.

-Andi
