Return-Path: <linux-kernel-owner+w=401wt.eu-S1754697AbZCMI5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697AbZCMI5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbZCMI5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:57:33 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:60065 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbZCMI5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:57:32 -0400
Date: Fri, 13 Mar 2009 09:59:30 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@snapgear.com>, Rob Landley <rob@landley.net>,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       linux-next@vger.kernel.org
Subject: Re: make headers_install broken for ARCH=m68k in 2.6.29-rc7.
Message-ID: <20090313085930.GA19274@uranus.ravnborg.org>
References: <200903120437.03837.rob@landley.net> <20090312210216.GB14205@uranus.ravnborg.org> <10f740e80903121540i30fdaddr600ce21f4159530a@mail.gmail.com> <200903122225.04560.rob@landley.net> <49BA0599.6070206@snapgear.com> <20090313082555.GA19045@uranus.ravnborg.org> <10f740e80903130133r130b8713v690437f0f38eb0b8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10f740e80903130133r130b8713v690437f0f38eb0b8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 09:33:18AM +0100, Geert Uytterhoeven wrote:
> On Fri, Mar 13, 2009 at 09:25, Sam Ravnborg <sam@ravnborg.org> wrote:
> > On Fri, Mar 13, 2009 at 05:04:57PM +1000, Greg Ungerer wrote:
> >> I pretty quick time I can fix up the last couple on the above list.
> >> But do we want to put all that change into 2.6.29-rc at this point?
> >
> > In general we do not want to have headers_check broken in mainline,
> 
> headers_check is not broken, headers_install is.
> 
> Hmm, in some sense headers_check _is_ broken, as it doesn't notice
> headers_install
> installs headers that refer to other headers that are not installed...
This is what scripts/headers_check are supposed to do - strange.

> Greg, I had a quick look at your signcontext.h and signal.h merge, and the MMU
> part seems to be OK.
> 
> However, some of the installed headers still have checks for CONFIG_MMU:
> 
> param.h:#ifdef CONFIG_MMU
> sigcontext.h:#ifndef CONFIG_MMU
> sigcontext.h:#ifdef CONFIG_MMU
> siginfo.h:#ifdef CONFIG_MMU
> siginfo.h:#ifdef CONFIG_MMU
> siginfo.h:#endif /* CONFIG_MMU */
> swab.h:#elif defined(CONFIG_MMU)
> 
> so these have to be added to the generic unifdef-y list (is that
> include/asm-generic/Kbuild.asm?).

include/asm-generic/Kbuild.asm impacts all architectures so be carefull there.
It looks like some updates to arch/m68k/include/asm/Kbuild is needed,
and not the generic list of files to export.

Also use og CONFIG_MMU suprises me.
We used #ifdef __uClinux__ in the non-merged headers to avoid use
of a CONFIG_* symbol that is not valid outside the kernel namespace.
So if param.h in m68k uses CONFIG_MMU it is broken.

	Sam
