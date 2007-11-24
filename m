Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbXKXNLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbXKXNLT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 08:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbXKXNLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 08:11:09 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:2485 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXKXNLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 08:11:07 -0500
X-IronPort-AV: i="4.21,460,1188792000"; 
   d="scan'208"; a="44147993:sNHT30967006"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Bryan Wu" <cooloney.lkml@gmail.com>
Subject: Re: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash controller driver support in bf5xx_nand driver
Date: Sat, 24 Nov 2007 08:11:35 -0500
User-Agent: KMail/1.9.5
Cc: "David Woodhouse" <dwmw2@infradead.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Bryan Wu" <bryan.wu@analog.com>,
       "Michael Hennerich" <michael.hennerich@analog.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       uclinux-dist-devel@blackfin.uclinux.org
References: <1195812893-26312-1-git-send-email-bryan.wu@analog.com> <1195886608.25590.59.camel@pmac.infradead.org> <386072610711232315u13c8b685jbf6c44c6688ba5f@mail.gmail.com>
In-Reply-To: <386072610711232315u13c8b685jbf6c44c6688ba5f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711240811.36342.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 24 Nov 2007 13:11:04.0451 (UTC) FILETIME=[77C8B530:01C82E9B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 24 Nov 2007 02:15, Bryan Wu pondered:
> On Nov 24, 2007 2:43 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> >
> > On Fri, 2007-11-23 at 17:04 -0500, Robin Getz wrote:
> > > It could be a runtime if() but we don't currently have the is_mach() all
> > > set up properly today.
> > >
> > > This is because on most systems that Blackfin ships on - memory is the
> > > dominate cost of the system, and end users don't want to take the either
> > > the storage (flash) hit of having code they don't use, or the run time
> > > (DRAM) overhead. They are fine with compiling 2 kernels for two
> > > platforms if it means things are cheaper. :)
> > >
> > > That being said, we still need to go back, and add things properly - and
> > > just let gcc optimise things away if it is not used - c code is more
> > > maintainable than all the ifdefs we have today.
> > >
> > > This is the goal - it will just take a little bit to get there.
> >
> > For now I suspect you could at least define machine_is_bf52x() and
> > machine_is_bf54x() which are hard-coded to either zero or one according
> > to the configuration, and at least you wouldn't need to add ifdefs to
> > drivers.
> >
> 
> We got some plan to do this, but maybe cpu_is_bf52x() and
> cpu_is_bf54x() are better.

Which was one of the reasons I think we were waiting/confused. There doesn't 
seem to be any consistancy between:

cpu_is_

which I assume refers to specific processor/chipset/SoC implementation?
cpu_is_ixp42x
cpu_is_ixp43x
cpu_is_ixp46x

mach_is_

which I assume refers to a specific platform:

mach_is_dreamcast
mach_is_hp6xx
mach_is_r7780mp
mach_is_r7780rp

machine_is_xxxx

which I assume refers to a specific platform:

machine_is_jornada56x
machine_is_jornada720
machine_is_nokia770

So, we should use cpu_is_ as Bryan suggested?

-Robin
