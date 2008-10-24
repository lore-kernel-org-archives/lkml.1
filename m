Return-Path: <linux-kernel-owner+w=401wt.eu-S1755176AbYJXXoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176AbYJXXoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYJXXoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:44:16 -0400
Received: from mk-outboundfilter-5.mail.uk.tiscali.com ([212.74.114.1]:34726
	"EHLO mk-outboundfilter-5.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751321AbYJXXoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:44:15 -0400
X-Trace: 98338152/mk-outboundfilter-5.mail.uk.tiscali.com/F2S/$F2S-NILDRAM-ACCEPTED/f2s-nildram-customers/195.149.44.6
X-SBRS: None
X-RemoteIP: 195.149.44.6
X-IP-MAIL-FROM: alistair@devzero.co.uk
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAGP6AUnDlSwG/2dsb2JhbACBdsApg08
X-IronPort-AV: E=Sophos;i="4.33,481,1220223600"; 
   d="scan'208";a="98338152"
X-IP-Direction: IN
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.28-rc1
Date: Sat, 25 Oct 2008 00:44:12 +0100
User-Agent: KMail/1.10.1 (Linux/2.6.28-rc1-damocles; KDE/4.1.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk> <20081024191552.GA14894@uranus.ravnborg.org>
In-Reply-To: <20081024191552.GA14894@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810250044.12372.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 October 2008 20:15:52 Sam Ravnborg wrote:
> On Fri, Oct 24, 2008 at 12:24:38PM +0100, Alistair John Strachan wrote:
> > On Friday 24 October 2008 05:10:29 Linus Torvalds wrote:
> > > It's been two weeks, so it's time to close the merge window. A
> > > 2.6.28-rc1 is out there, and it's hopefully all good.
> >
> > It seems if you have a broken asm/ symlink in include/ (which happened as
> > a result of the x86 header moves, for me) the kernel won't try to update
> > it appropriately, and this breaks "make prepare".
> >
> > $ make    ARCH=x86_64 prepare
> >   CHK     include/linux/version.h
> >   CHK     include/linux/utsrelease.h
> >   GEN     include/asm/asm-offsets.h
> > /bin/sh: include/asm/asm-offsets.h: No such file or directory
> > make[1]: *** [include/asm/asm-offsets.h] Error 1
> > make: *** [prepare0] Error 2
> >
> > rm -f include/asm fixes it
> >
> > This was just from taking a 2.6.27 tree, git clean -d -f, git pull, make
> > oldconfig. Might be a nice thing to fix?
>
> The following patch add another special case hwre we delete stale symlinks.
> In my limited testing it fixes the issue - can you try to give it a spin.

Fixes it here, thanks.

-- 
Cheers,
Alistair.
