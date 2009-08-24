Return-Path: <linux-kernel-owner+w=401wt.eu-S1752686AbZHXOqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686AbZHXOqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 10:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZHXOqd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 10:46:33 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:39692 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbZHXOqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 10:46:32 -0400
Date: Mon, 24 Aug 2009 20:15:42 +0530
From: "M. Mohan Kumar" <mohan@in.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       tony.luck@intel.com, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       kamezawa.hiroyu@jp.fujitsu.com, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, bernhard.walle@gmx.de,
       Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [Patch 6/8] powerpc: add CONFIG_KEXEC_AUTO_RESERVE
Message-ID: <20090824144542.GB11956@in.ibm.com>
Reply-To: mohan@in.ibm.com
References: <20090821065637.4855.32234.sendpatchset@localhost.localdomain> <20090821065739.4855.19179.sendpatchset@localhost.localdomain> <1251121443.10645.56.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251121443.10645.56.camel@concordia>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:44:03PM +1000, Michael Ellerman wrote:
> On Fri, 2009-08-21 at 02:55 -0400, Amerigo Wang wrote:
> > Introduce a new config option KEXEC_AUTO_RESERVE for powerpc.
> > 
> > Index: linux-2.6/arch/powerpc/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/arch/powerpc/Kconfig
> > +++ linux-2.6/arch/powerpc/Kconfig
> > @@ -346,6 +346,17 @@ config KEXEC
> >  	  support.  As of this writing the exact hardware interface is
> >  	  strongly in flux, so no good recommendation can be made.
> >  
> > +config KEXEC_AUTO_RESERVE
> > +	bool "automatically reserve memory for kexec kernel"
> > +	depends on KEXEC
> > +	default y
> > +	---help---
> > +	  Automatically reserve memory for a kexec kernel, so that you don't
> > +	  need to specify numbers for the "crashkernel=X@Y" boot option,
> > +	  instead you can use "crashkernel=auto". To make this work, you need
> > +	  to have more than 4G memory. On PPC, 256M is reserved, 1/32 memory
> > +	  on PPC64, but it will not exceed 1T/32.
> 
> That aside, I don't see how this will be useful in practice, if it only
> works for memory sizes over 4G? Or are we saying that people with less
> than 4G don't need crash kernels? If we're not saying that, those users,
> or those users' distros, still need to do some logic to work out if they
> have < 4GB of memory and if so pick a crash kernel size. So why can't
> they pick the size in the > 4GB case also?

True, I wanted to test the patch and when tested on a ppc64 machine which
has RAM less than 4GB, I have to modify arch_default_crash_size routine to
return 256MB (I didn't have a PPC64 machine with more than 4GB RAM handy).
So its better to consider machines with less than 4GB RAM also.

PPC64 crashkernel base is always 32MB. So at least ppc64 code should have
its own arch_default_crash_base to return 32MB to avoid the kernel warning
message "Crash kernel location must be 0x2000000"

Regards,
M. Mohan Kumar
