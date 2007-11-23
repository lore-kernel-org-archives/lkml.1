Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbXKWI74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbXKWI74 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 03:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXKWI7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 03:59:47 -0500
Received: from mail-in-16.arcor-online.net ([151.189.21.56]:40125 "EHLO
	mail-in-16.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753284AbXKWI7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 03:59:46 -0500
Date: Fri, 23 Nov 2007 09:59:43 +0100
From: Andreas Herrmann <aherrman@arcor.de>
To: "Kirill A. Shutemov" <k.shutemov@velesys.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1
Message-ID: <20071123085943.GA5306@devil>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <20071122102205.GD7085@localhost.localdomain> <20071122161826.61515a6d.akpm@linux-foundation.org> <alpine.LFD.0.9999.0711230146190.25057@localhost.localdomain> <20071123060544.GB28946@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071123060544.GB28946@localhost.localdomain>
User-Agent: mutt-ng/devel-r804 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 08:05:44AM +0200, Kirill A. Shutemov wrote:
> On [Fri, 23.11.2007 01:48], Thomas Gleixner wrote:
> > On Thu, 22 Nov 2007, Andrew Morton wrote:
> > 
> > > On Thu, 22 Nov 2007 12:22:05 +0200 "Kirill A. Shutemov" <k.shutemov@velesys.com> wrote:
> > > 
> > > > On x86_64 'uname -m' return 'x86'.  It break many userspace programs. apt
> > > > and rpm for example.
> > > > 
> > > 
> > > Yes, there have been various discussions about this.  I think Sam is cooking up
> > > a fix?
> > 
> > http://lkml.org/lkml/2007/11/19/323
> > 
> > I push it Linus wards ASAP.
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 116b03a..7aa1dc6 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -11,10 +11,9 @@ endif
>  $(srctree)/arch/x86/Makefile%: ;
>  
>  ifeq ($(CONFIG_X86_32),y)
> +        UTS_MACHINE := i386
>          include $(srctree)/arch/x86/Makefile_32
>  else
> +        UTS_MACHINE := x86_64
>          include $(srctree)/arch/x86/Makefile_64
>  endif
> 
> Many programs expect i686 on Pentium II.


Yes, but this is done during boot.
Then the kernel overwrites "i386" to become "i686" for such CPUs.
That is why I've seen "x66" after boot when UTS_MACHINE at build-time
was "x86" with 'make ARCH=x86'.
For more details see:

http://marc.info/?l=linux-kernel&m=119521309415545&w=2


Regards,

Andreas

