Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbYJTWek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbYJTWek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 18:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYJTWeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 18:34:31 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:37211 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbYJTWea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 18:34:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UZV+n8I8uXk4ilqGIWWInCApF38r8+lgLii04yVdR2VlrsEk7TgXGomBQwo8A8a68N
         Ave4s7ax9OPU/Sy8re0KLm77vv9HO9g/0WWF+X62426wKSCjx44EVHgd133aFDzmlpfd
         Qa2zLasgTeFRBBc6lfEjTaoQQTraXF41Mu/Xs=
Date: Mon, 20 Oct 2008 18:34:35 -0400
From: "J.R. Mauro" <jrm8005@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Christopher Harrer <charrer@alacritech.com>,
       Michael Miles <mmiles@alacritech.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linus@kroah.com
Subject: Re: linux-next: build failure
Message-ID: <20081020223435.GA11079@localhost>
References: <20081020230420.aa85f83b.sfr@canb.auug.org.au> <20081020154857.GC24666@kroah.com> <3aaafc130810200933s7299378eg6924089a58b9778a@mail.gmail.com> <20081020165142.GA7166@kroah.com> <20081020204750.GA22377@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081020204750.GA22377@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2008 at 01:47:50PM -0700, Greg KH wrote:
> On Mon, Oct 20, 2008 at 09:51:42AM -0700, Greg KH wrote:
> > On Mon, Oct 20, 2008 at 12:33:29PM -0400, J.R. Mauro wrote:
> > > On Mon, Oct 20, 2008 at 11:48 AM, Greg KH <greg@kroah.com> wrote:
> > > > On Mon, Oct 20, 2008 at 11:04:20PM +1100, Stephen Rothwell wrote:
> > > >> Hi Greg,
> > > >>
> > > >> Today's linux-next build (powerpc allyesconfig) failed like this:
> > > >>
> > > >> In file included from drivers/staging/sxg/sxg.c:77:
> > > >> drivers/staging/sxg/sxghif.h:859: error: expected '=', ',', ';', 'asm' or '__attribute__' before 'Compilation'
> > > >> drivers/staging/sxg/sxg.c: In function 'sxg_transmit_packet':
> > > >> drivers/staging/sxg/sxg.c:1949: error: 'SXG_SGL_BUF_SIZE' undeclared (first use in this function)
> > > >> drivers/staging/sxg/sxg.c:1958: error: implicit declaration of function 'SXG_SGL_BUFFER'
> > > >> drivers/staging/sxg/sxg.c:1958: warning: assignment makes pointer from integer without a cast
> > > >> drivers/staging/sxg/sxg.c: In function 'sxg_mcast_set_mask':
> > > >> drivers/staging/sxg/sxg.c:2846: warning: format '%llx' expects type 'long long unsigned int', but argument 5 has type 'u64'
> > > >>
> > > >> I applied the following patch.
> > > >
> > > > Ah, doh, sorry, I should have caught that.  I'll go apply this to the
> > > > tree, thanks.
> > > 
> > > Greg,
> > > 
> > > The slicoss driver also from Alacritech looks like it needs a depends
> > > on X86 as well. Should the sxg and slicoss drivers from Alacritech be
> > > doing things like this (sxg/sxghif.h:851, slicoss/slicoss.c:960):
> > 
> > Yes, it needs it too.
> 
> Hm, it already has this dependancy.  In drivers/staging/slicoss/Kconfig
> we have:
> 	config SLICOSS
> 		tristate "Alacritech Gigabit IS-NIC support"
> 		depends on PCI && X86 && NETDEV_1000
> 
> So we should be fine here.

Sorry about that, had to pull from Linus's tree

> 
> thanks,
> 
> greg k-h
