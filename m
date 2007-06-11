Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbXFKRUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbXFKRUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 13:20:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbXFKRUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 13:20:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49187 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbXFKRUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 13:20:41 -0400
Date: Mon, 11 Jun 2007 13:20:06 -0400
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move the kernel to 16MB for NUMA-Q
Message-ID: <20070611172006.GI9174@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Whitcroft <apw@shadowen.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Steve Fox <drfickle@us.ibm.com>, Mel Gorman <mel@csn.ul.ie>,
	linux-kernel@vger.kernel.org
References: <466D550C.4030600@shadowen.org> <63a08cc7547f14065becdf9a94d0d529@pinky> <20070611091558.f468f205.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611091558.f468f205.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 09:15:58AM -0700, Andrew Morton wrote:
 > On Mon, 11 Jun 2007 15:32:10 +0100 Andy Whitcroft <apw@shadowen.org> wrote:
 > 
 > > 
 > > We are seeing corruption of the decompressed kernel.  It is suspected
 > > that this is platform specific as it has yet to be seen on any
 > > other x86.  Move the kernel to the 16MB boundary.
 > > 
 > > Signed-off-by: Andy Whitcroft <apw@shadowen.org>
 > > ---
 > > diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
 > > index 7e1950f..89e6bf4 100644
 > > --- a/arch/i386/Kconfig
 > > +++ b/arch/i386/Kconfig
 > > @@ -817,6 +817,7 @@ config CRASH_DUMP
 > >  
 > >  config PHYSICAL_START
 > >  	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
 > > +	default "0x1000000" if X86_NUMAQ
 > >  	default "0x100000"
 > >  	help
 > >  	  This gives the physical address where the kernel is loaded.
 > 
 > grumble.  If it's a BIOS bug then OK.  But if it is indeed a kernel bug
 > then this patch didn't make it go away and it shall return to haunt us.

FWIW, waay back when (sometime last year if memory serves)
Linus suggested changing the default to 0x1000000 for all x86.
The reasoning was some performance microoptimisation regarding
4MB aligned TLBs iirc.

The details have long since evaded my memory, but as an experiment,
I made the change to the Fedora kernel.  FC5,FC6 and F7 have been
this way for a while now, with no obvious problems. Ditto RHEL5.
We did get some performance numbers at the time of the change,
but they weren't amazing (basically in the noise).
Given it never seemed to actually get worse, I never got around
to reverting it..

	Dave

-- 
http://www.codemonkey.org.uk
