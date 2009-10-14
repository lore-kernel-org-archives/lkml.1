Return-Path: <linux-kernel-owner+w=401wt.eu-S1757125AbZJNHnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125AbZJNHnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756113AbZJNHnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:43:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50851 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755780AbZJNHnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:43:49 -0400
Date: Wed, 14 Oct 2009 08:42:58 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix sparsemem configuration
Message-ID: <20091014074258.GA32288@flint.arm.linux.org.uk>
References: <20091005150530.GA12271@rmk-PC.arm.linux.org.uk> <20091013194950.2f8f0fe1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013194950.2f8f0fe1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 07:49:50PM -0700, Andrew Morton wrote:
> On Mon, 5 Oct 2009 16:05:30 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:
> 
> > Currently, sparsemem is only available if EXPERIMENTAL is enabled.
> > However, it hasn't ever been marked experimental.
> > 
> > It's been about four years since sparsemem was merged, and we have
> > platforms which depend on it; allow architectures to decide whether
> > sparsemem should be the default memory model.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > --
> >  mm/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 2477607..95b2965 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -67,7 +67,7 @@ config DISCONTIGMEM
> >  
> >  config SPARSEMEM
> >  	def_bool y
> > -	depends on SPARSEMEM_MANUAL
> > +	depends on (!SELECT_MEMORY_MODEL && ARCH_SPARSEMEM_ENABLE) || SPARSEMEM_MANUAL
> >  
> >  config FLATMEM
> >  	def_bool y
> 
> Can you suggest which kernel version(s) we should merge this into?  I'm
> struggling.

I don't see any reason not to merge it into the current -rc.  Not sure
about -stable since there hasn't been a bug report against the machines
which currently use sparsemem.  That's not to say that people aren't
using it - they probably believe CONFIG_EXPERIMENTAL needs to be set as
per the machine's defconfig.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
