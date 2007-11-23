Return-Path: <linux-kernel-owner+w=401wt.eu-S1757799AbXKWWEi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799AbXKWWEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 17:04:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbXKWWEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 17:04:30 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:32487 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbXKWWEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 17:04:30 -0500
X-IronPort-AV: i="4.21,459,1188792000"; 
   d="scan'208"; a="56925136:sNHT30093091"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: [PATCH 1/1] [MTD/NAND]: Add Blackfin BF52x on-chip NAND Flash controller driver support in bf5xx_nand driver
Date: Fri, 23 Nov 2007 17:04:59 -0500
User-Agent: KMail/1.9.5
Cc: "Bryan Wu" <cooloney.lkml@gmail.com>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Bryan Wu" <bryan.wu@analog.com>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       "Michael Hennerich" <michael.hennerich@analog.com>
References: <1195812893-26312-1-git-send-email-bryan.wu@analog.com> <386072610711230625k23b68e49q6090b7eb27c2c039@mail.gmail.com> <20071123135212.7c483aae@laptopd505.fenrus.org>
In-Reply-To: <20071123135212.7c483aae@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711231704.59948.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 23 Nov 2007 22:04:28.0380 (UTC) FILETIME=[D132F9C0:01C82E1C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 23 Nov 2007 16:52, Arjan van de Ven pondered:
> On Fri, 23 Nov 2007 22:25:29 +0800
> "Bryan Wu" <cooloney.lkml@gmail.com> wrote:
> 
> > On Nov 23, 2007 6:19 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> > >
> > > On Fri, 2007-11-23 at 18:14 +0800, Bryan Wu wrote:
> > > >
> > > > +#ifdef CONFIG_BF54x
> > > >         /* Setup DMAC1 channel mux for NFC which shared with SDH
> > > > */ val = bfin_read_DMAC1_PERIMUX();
> > > >         val &= 0xFFFE;
> > > >         bfin_write_DMAC1_PERIMUX(val);
> > > >         SSYNC();
> > > > -
> > > > +#endif
> > >
> > > You can't build a multiplatform kernel which runs on BF52x and
> > > BF54x?
> > 
> > There are some hardware difference between BF52x and BF54x. We have
> > to do this.
> > 
> 
> well does it need to be an #ifdef, or can it be a runtime if() ?

It could be a runtime if() but we don't currently have the is_mach() all set 
up properly today.

This is because on most systems that Blackfin ships on - memory is the 
dominate cost of the system, and end users don't want to take the either the 
storage (flash) hit of having code they don't use, or the run time (DRAM) 
overhead. They are fine with compiling 2 kernels for two platforms if it 
means things are cheaper. :)

That being said, we still need to go back, and add things properly - and just 
let gcc optimise things away if it is not used - c code is more maintainable 
than all the ifdefs we have today.

This is the goal - it will just take a little bit to get there.

-Robin
