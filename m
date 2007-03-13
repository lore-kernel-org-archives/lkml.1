Return-Path: <linux-kernel-owner+w=401wt.eu-S1750703AbXCMWe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750703AbXCMWe0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 18:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXCMWeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 18:34:25 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:46225 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbXCMWeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 18:34:25 -0400
X-Originating-Ip: 74.102.209.62
Date: Tue, 13 Mar 2007 18:04:46 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org
Subject: Re: module.h and moduleparam.h:  more header file pedantry
In-Reply-To: <20070313220517.GA5623@martell.zuzino.mipt.ru>
Message-ID: <Pine.LNX.4.64.0703131804080.3737@localhost.localdomain>
References: <Pine.LNX.4.64.0703121252430.19315@CPE00045a9c397f-CM001225dbafb6>
 <20070313220517.GA5623@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (cached,
	score=-16.723, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, TW_KM 0.08)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Alexey Dobriyan wrote:

> On Mon, Mar 12, 2007 at 12:59:20PM -0400, Robert P. J. Day wrote:
> >   to my surprise, i learned only today that module.h includes
> > moduleparam.h, which flies in the face of all of the documentation
> > i've ever read which was adamant that i *had* to include moduleparam.h
> > if i was using parameters. i'm guessing this comes as a surprise to
> > the 400+ header files which include both unnecessarily.
> >
> >   so ... in a perfect world, should a module source file that doesn't
> > use parameters *at all* need to include moduleparam.h?
>
> Probably not.
>
> > as it stands
> > now, yes, it does, given some ugly inter-dependencies between the two
> > files.
> >
> >   so, at the very least, programmers can stop including moduleparam.h,
> > unless there's a cleaner way to do all that.
>
> Regardless, of what you'll do: cross-compile test!
>
> After aforementioned removal and adding "struct kernel_param;"
>
> + akmk arm-assabet -k
>   CHK     include/linux/version.h
> make[2]: `include/asm-arm/mach-types.h' is up to date.
>   Using /home/linux/linux-irq-flags-t as source for kernel
>   GEN     /home/linux/build/arm-assabet/Makefile
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   CC      arch/arm/nwfpe/fpmodule.o
> arch/arm/nwfpe/fpmodule.c:179: error: syntax error before string constant
> arch/arm/nwfpe/fpmodule.c:179: warning: type defaults to `int' in declaration of `__MODULE_INFO'
> arch/arm/nwfpe/fpmodule.c:179: warning: function declaration isn't a prototype
> arch/arm/nwfpe/fpmodule.c:179: warning: data definition has no type or storage class

oh, i've already been by that and figured out what's going on.  i'm
going to summarize this on the KJ wiki.  it's really quite the mess.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
