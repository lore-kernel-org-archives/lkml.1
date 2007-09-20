Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbXITDyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbXITDyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 23:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbXITDyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 23:54:39 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:39575 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbXITDyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 23:54:38 -0400
Date: Thu, 20 Sep 2007 12:54:12 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: David McCullough <David_Mccullough@securecomputing.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
       Bernd Schmidt <bernd.schmidt@analog.com>,
       Greg Ungerer <gerg@snapgear.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ysato@users.sourceforge.jp,
       miles@lsi.nec.co.jp, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH] binfmt_flat: minimum support for theBlackfin relocations
Message-ID: <20070920035412.GA31501@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Mike Frysinger <vapier.adi@gmail.com>,
	David McCullough <David_Mccullough@securecomputing.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	uclinux-dist-devel@blackfin.uclinux.org, bryan.wu@analog.com,
	Bernd Schmidt <bernd.schmidt@analog.com>,
	Greg Ungerer <gerg@snapgear.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	ysato@users.sourceforge.jp, miles@lsi.nec.co.jp,
	linux-m32r@ml.linux-m32r.org
References: <1190102965.4406.9.camel@roc-desktop> <200709192131.09469.rgetz@blackfin.uclinux.org> <20070920015525.GA16615@securecomputing.com> <20070920031807.GA31263@linux-sh.org> <8bd0f97a0709192042g67f13337nf62978768b64ff80@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0709192042g67f13337nf62978768b64ff80@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2007 at 11:42:53PM -0400, Mike Frysinger wrote:
> On 9/19/07, Paul Mundt <lethal@linux-sh.org> wrote:
> > On Thu, Sep 20, 2007 at 11:55:25AM +1000, David McCullough wrote:
> > > Jivin Robin Getz lays it down ...
> > > > On Tue 18 Sep 2007 04:09, Bryan Wu pondered:
> > > > > This just adds minimum support for the Blackfin relocations,
> > > > > since we don't have enough space in each reloc. The idea
> > > > > is to store a value with one relocation so that subsequent ones can
> > > > > access it.
> > > >
> > > > Adding the other appropriate maintainers. for h8, m32r, sh and v850.
> > >
> > > Looks fine to me,  obviously impacts the existing arches very little.
> > > Can't see why it shouldn't get included,
> >
> > I find it a bit disconcerting that blackfin already depends on this
> > in-tree without there being any earlier discussion on making these
> > changes.
> 
> not really ... this patch was posted before but was lost in the
> shuffle ... and i'm not quite sure what you mean by "depends on" ...
> if you want to use the FLAT file format on a Blackfin processor, then
> this patch is needed, but that isnt the only file format that works on
> the Blackfin port as we also have FDPIC ELF
> 
What I mean by "depends on" is that for what you are attempting to patch,
your architecture has an in-tree dependency on something that hasn't been
discussed. It's more than a bit backwards to push the follow-up bits before
even getting an Ack on the changes you want to make in the common code.

The fact you have other options is great, so at least you haven't shafted
all of your git kernel users, but that's not the point. You should not be
pushing things in to the kernel that have dependencies on API changes
that may or may not be merged, especially when you're breaking the entire
kernel for your platform (and the ability to bisect for those users) in
the process.
