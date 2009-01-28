Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbZA1Wiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbZA1Wiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 17:38:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbZA1Wih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 17:38:37 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:33182 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZA1Wig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 17:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m4tj8LrMA4AgSsw0WihwkZ9C3AKS4iJw48W18cwrR0eRl2Cn3d2X1qc5jOtnsNrtVZ
         tMbMTP4R4ou0O5bO/Zt6DBGqJom6OmZbhdMtTegjb7P89mO63bpuuLtxWu482td5ouiY
         aPgBpIhFRNy2AoCH++42f3zLNoOGBhCTl7PP8=
Subject: Re: [PATCH] x86: do not expose CONFIG_BSWAP to userspace
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "H. Peter Anvin" <hpa@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4980D913.3000505@zytor.com>
References: <20090127222825.GA27097@elte.hu>
	 <alpine.LFD.2.00.0901271441280.3123@localhost.localdomain>
	 <1233106614.3256.6.camel@localhost.localdomain>
	 <200901281337.52294.arnd@arndb.de>  <49809A65.2090501@kernel.org>
	 <1233170532.6717.49.camel@brick>
	 <alpine.LFD.2.00.0901281141510.3123@localhost.localdomain>
	 <1233172994.6717.56.camel@brick>  <4980CD51.70601@zytor.com>
	 <1233179884.6717.59.camel@brick>  <4980D913.3000505@zytor.com>
Content-Type: text/plain
Date: Wed, 28 Jan 2009 14:38:34 -0800
Message-Id: <1233182314.6717.66.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 14:15 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > I'm afraid my knowledge of gcc compiler flags for various models is
> > lacking, I used i486 as suggested, just wanted to make sure I understood
> > you corectly.
> 
> You did, but I misremembered... instead of having the __i386__, 
> __i486__, __i586__, __i686__ being an additive chain as would make 
> sense, gcc just has __i386__ plus whichever corresponds to the -march= 
> option.  I keep forgetting this because it's just so incredibly dumb.
> 
> Bloody hell.  This really f*cks thing up.

> What's worse, they seem to simply be adding new options, so at this 
> point you'd actually need something like:
> 
> # if defined(__i486__) || defined(__i586__) || defined(__i686__) || \
> 	defined(__core2__) || defined(__k8__) || defined(__amdfam10__)
> 
> Worse, there isn't any kind of macro that can be used to compare for a 
> negative (i.e. not i386).

Well, that's unfortunate, how about we just export the BSWAP version
unconditionally and hope pure i386 just goes away someday?

> 
> This obviously is screaming to be abstracted away into a header of its 
> own, but it really can't be done cleanly as far as I can tell because of 
> this particular piece of major gcc braindamage.
> 
> So, one ends up doing something like:
> 
> #ifdef __i486__
> # define __CPU_HAVE_BSWAP
> #endif
> #ifdef __i586__
> # define __CPU_HAVE_BSWAP
> #endif
> 
> ... and so on, and have to keep this up to date with the latest 
> inventions of the gcc people.  *Sob.*

Unpleasant indeed.  Is there a byteswap builtin in gcc?  At least AVR32
seems to use it, but perhaps it's not generally exposed...perhaps we
could ask the gcc-folk?

Harvey

