Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbXGPJXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbXGPJXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 05:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbXGPJWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 05:22:55 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51439 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978AbXGPJWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 05:22:54 -0400
X-Originating-Ip: 74.102.207.204
Date: Mon, 16 Jul 2007 05:20:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: Mike Frysinger <vapier@gentoo.org>, paulus@samba.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] use __attribute__ in asm-powerpc
In-Reply-To: <Pine.LNX.4.62.0707161117150.1072@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.64.0707160519090.5261@localhost.localdomain>
References: <200707142336.10343.vapier@gentoo.org>
 <Pine.LNX.4.62.0707161117150.1072@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Geert Uytterhoeven wrote:

> On Sat, 14 Jul 2007, Mike Frysinger wrote:
> > Pretty much everyone uses "__attribute__" or "attribute", no one
> > uses "__attribute".  This patch tweaks the three places in asm-powerpc where
> > this comes up.  While only asm-powerpc/types.h is interesting (for userspace),
> > I did asm-powerpc/processor.h as well for consistency.
> >
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> > diff --git a/include/asm-powerpc/processor.h b/include/asm-powerpc/processor.h
> > index d947b16..2ce6ea6 100644
> > --- a/include/asm-powerpc/processor.h
> > +++ b/include/asm-powerpc/processor.h
> > @@ -153,9 +153,9 @@ struct thread_struct {
> >  	unsigned long	dabr;		/* Data address breakpoint register */
> >  #ifdef CONFIG_ALTIVEC
> >  	/* Complete AltiVec register set */
> > -	vector128	vr[32] __attribute((aligned(16)));
> > +	vector128	vr[32] __attribute__((aligned(16)));
>
> If the code is not exported to userspace (and thus not subject to
> different compilers), I think the preferred form is plain
> `attribute'.

compiler-gcc.h also defines the common form of the shortcut:

#define __aligned(x)                    __attribute__((aligned(x)))

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
