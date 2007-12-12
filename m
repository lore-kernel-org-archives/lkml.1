Return-Path: <linux-kernel-owner+w=401wt.eu-S1755714AbXLLBey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714AbXLLBey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 20:34:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbXLLBeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 20:34:46 -0500
Received: from ozlabs.org ([203.10.76.45]:60001 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbXLLBep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 20:34:45 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: Correct types for mod_devicetable.h (was: Re: m68k build failure)
Date: Wed, 12 Dec 2007 12:34:34 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Pierre Ossman <drzeus@drzeus.cx>, Al Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>, Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org> <200712032102.20353.rusty@rustcorp.com.au> <20071208215811.GD20441@stusta.de>
In-Reply-To: <20071208215811.GD20441@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712121234.35471.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 December 2007 08:58:11 Adrian Bunk wrote:
> On Mon, Dec 03, 2007 at 09:02:19PM +1100, Rusty Russell wrote:
> > On Sunday 02 December 2007 22:22:31 Geert Uytterhoeven wrote:
> > > On Sat, 1 Dec 2007, Pierre Ossman wrote:
> > > > Yeah, that could work. Have a header with stuff like this:
> > > >
> > > > typedef u16 __attribute__((aligned(2))) aligned_u16;
> > > > typedef u32 __attribute__((aligned(4))) aligned_u32;
> > >
> > > I gave it a try:
> >
> > This seems to turn a molehill into a mountain.
> >
> > We can change that mod_devicetable.h at any time; it's not supposed to be
> > a userspace API (the kernel build system doesn't count).
>
> module-init-tools is userspace and not shipped as part of the kernel
> build system...

But module-init-tools is *not* supposed to read this; that code is a 2.4 
backwards compatibility layer which should be removed (and certainly not 
enhanced to cover new types in mod_devicetable.h!).

I repeat: this is *only* for the internal modpost code.  

> > So, just insert two bits of padding in sdio_device_id and insert a
> > comment saying "/* Explicit padding: works even if we're cross-compiling
> > */".
>
> We had one such problem in 2.6.23 and now we had a similar one in 2.6.24.
>
> Getting the alignment issues automatically right would really be an
> improvement...

Not if it makes the code (even) more obscure.  Put an attribute((packed)) on 
every structure and add an explanation at the top of the file if it makes you 
feel safer (new additions to the file are likely to copy existing ones), and 
that's sufficient.

Hope that clarifies,
Rusty.
