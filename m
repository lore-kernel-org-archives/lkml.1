Return-Path: <linux-kernel-owner+w=401wt.eu-S1752736AbYCCLqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbYCCLqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 06:46:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbYCCLqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 06:46:40 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37155 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYCCLqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 06:46:39 -0500
Date: Mon, 3 Mar 2008 11:43:10 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Message-ID: <20080303114310.GA28139@flint.arm.linux.org.uk>
Mail-Followup-To: David Howells <dhowells@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Arch Mailing List <linux-arch@vger.kernel.org>,
	David Brownell <dbrownell@users.sourceforge.net>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <8260.1204541852@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8260.1204541852@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 10:57:32AM +0000, David Howells wrote:
> H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > +#define S8_C(x)	 x
> > +#define U8_C(x)  x ## U
> > +#define S16_C(x) x
> > +#define U16_C(x) x ## U
> > +#define S32_C(x) x
> > +#define U32_C(x) x ## U
> > +#define S64_C(x) x ## LL
> > +#define U64_C(x) x ## ULL
> 
> And #if defined(__ASSEMBLY__), just splat x through as is.

We already have something like this on ARM - include/asm-arm/memory.h

/*
 * Allow for constants defined here to be used from assembly code
 * by prepending the UL suffix only with actual C code compilation.
 */
#ifndef __ASSEMBLY__
#define UL(x) (x##UL)
#else
#define UL(x) (x)
#endif

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
