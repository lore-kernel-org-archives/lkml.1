Return-Path: <linux-kernel-owner+w=401wt.eu-S1754424AbYCCMkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424AbYCCMkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbYCCMki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:40:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:56809 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbYCCMkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:40:37 -0500
Date: Mon, 3 Mar 2008 13:40:50 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: David Howells <dhowells@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Message-ID: <20080303124050.GA24841@uranus.ravnborg.org>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <8260.1204541852@redhat.com> <20080303114310.GA28139@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303114310.GA28139@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 11:43:10AM +0000, Russell King wrote:
> On Mon, Mar 03, 2008 at 10:57:32AM +0000, David Howells wrote:
> > H. Peter Anvin <hpa@zytor.com> wrote:
> > 
> > > +#define S8_C(x)	 x
> > > +#define U8_C(x)  x ## U
> > > +#define S16_C(x) x
> > > +#define U16_C(x) x ## U
> > > +#define S32_C(x) x
> > > +#define U32_C(x) x ## U
> > > +#define S64_C(x) x ## LL
> > > +#define U64_C(x) x ## ULL
> > 
> > And #if defined(__ASSEMBLY__), just splat x through as is.
> 
> We already have something like this on ARM - include/asm-arm/memory.h
> 
> /*
>  * Allow for constants defined here to be used from assembly code
>  * by prepending the UL suffix only with actual C code compilation.
>  */
> #ifndef __ASSEMBLY__
> #define UL(x) (x##UL)
> #else
> #define UL(x) (x)
> #endif

And in linux/const.h we have yet another variant:
/* Some constant macros are used in both assembler and
 * C code.  Therefore we cannot annotate them always with
 * 'UL' and other type specifiers unilaterally.  We
 * use the following macros to deal with this.
 *
 * Similarly, _AT() will cast an expression with a type in C, but
 * leave it unchanged in asm.
 */

#ifdef __ASSEMBLY__
#define _AC(X,Y)        X
#define _AT(T,X)        X
#else
#define __AC(X,Y)       (X##Y)
#define _AC(X,Y)        __AC(X,Y)
#define _AT(T,X)        ((T)(X))
#endif

Not as typestrict as hpa's and arm's version but
used in a few placed already.

	Sam
