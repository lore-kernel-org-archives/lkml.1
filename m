Return-Path: <linux-kernel-owner+w=401wt.eu-S1765325AbYD3U2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765325AbYD3U2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763392AbYD3U2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:28:32 -0400
Received: from fed1rmmtao106.cox.net ([68.230.241.40]:65478 "EHLO
	fed1rmmtao106.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbYD3U2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:28:31 -0400
X-Greylist: delayed 798 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 16:28:31 EDT
Date: Wed, 30 Apr 2008 13:15:08 -0700
From: Tom Rini <trini@kernel.crashing.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] /dev/mem gcc weak function workaround
Message-ID: <20080430201508.GA17795@smtp.west.cox.net>
References: <20080430013108.GA18207@linux-os.sc.intel.com> <20080429.212833.192304794.davem@davemloft.net> <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEF7D18E@orsmsx423.amr.corp.intel.com>
Organization: Embedded Alley Solutions, Inc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 05:49:46AM -0700, Pallipadi, Venkatesh wrote:
>  
> 
> >-----Original Message-----
> >From: David Miller [mailto:davem@davemloft.net] 
> >Sent: Tuesday, April 29, 2008 9:29 PM
> >To: Pallipadi, Venkatesh
> >Cc: mingo@elte.hu; tglx@linutronix.de; hpa@zytor.com; 
> >akpm@linux-foundation.org; linux-kernel@vger.kernel.org
> >Subject: Re: [PATCH] /dev/mem gcc weak function workaround
> >
> >From: Venki Pallipadi <venkatesh.pallipadi@intel.com>
> >Date: Tue, 29 Apr 2008 18:31:09 -0700
> >
> >> Some flavors of gcc 4.1.0 and 4.1.1 seems to have trouble 
> >understanding
> >> weak function definitions. Calls to function from the same 
> >file where it is
> >> defined as weak _may_ get inlined, even when there is a 
> >non-weak definition of
> >> the function elsewhere. I tried using attribute 'noinline' 
> >which does not
> >> seem to help either.
> >> 
> >> One workaround for this is to have weak functions defined in 
> >different
> >> file as below. Other possible way is to not use weak 
> >functions and go back
> >> to ifdef logic.
> >> 
> >> There are few other usages in kernel that seem to depend on 
> >weak (and noinline)
> >> working correctly, which can also potentially break and 
> >needs such workarounds.
> >> Example -
> >> mach_reboot_fixups() in arch/x86/kernel/reboot.c is one such 
> >call which
> >> is getting inlined with a flavor of gcc 4.1.1.
> >> 
> >> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> >> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> >
> >This sounds like a bug.  And if gcc does multi-file compilation it
> >can in theory do the same mistake even if you move it to another
> >file.
> >
> >We need something more bulletproof here.
> >
> 
> The references here
> http://gcc.gnu.org/ml/gcc-bugs/2006-05/msg02801.html
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=27781
> 
> seem to suggest that the bug is only with weak definition in the same
> file.
> So, having them in a different file should be good enough workaround
> here.
> 
> Tom: Comments?

Yes, that matches my recollection.  some versions of gcc 4.1.0 (and
possibly 4.1.1, it wouldn't be hard to check) could not handle having a
regular and weak function in the same file (I hit this trying to do
some abstraction or another in kgdb, using includes) but it was correct
if in separate files.  I assume blacklisting 4.1.0 is out of the
question :)

-- 
Tom Rini
