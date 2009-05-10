Return-Path: <linux-kernel-owner+w=401wt.eu-S1752699AbZEJIxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699AbZEJIxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 04:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZEJIwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 04:52:55 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:40769 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbZEJIwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 04:52:53 -0400
Date: Sun, 10 May 2009 10:55:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@mit.edu>
Subject: Re: Minimal linker script
Message-ID: <20090510085504.GA18719@uranus.ravnborg.org>
References: <20090509080006.GA22617@uranus.ravnborg.org> <4A061158.3010604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A061158.3010604@zytor.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 09, 2009 at 04:27:20PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >  *      . = START;
> >  *      __init_begin = .;
> >  *      HEAD_SECTION
> >  *      INIT_TEXT_SECTION(PAGE_SIZE)
> >  *      INIT_DATA_SECTION(...)
> >  *      PERCPU(PAGE_SIZE)
> >  *      __init_end = .;
> >  *
> >  *      __text_begin = .;
> >  *      TEXT_SECTION = 0
> >  *      __text_end = .;
> >  *
> >  *      __data_begin = .;
> >  *      RO_DATA_SECTION(PAGE_SIZE)
> >  *      RW_DATA_SECTION(...)
> >  *      __data_end = .;
> >  *
> >  *      EXCEPTION_TABLE(...)
> >  *      NOTES
> >  *
> >  *      __bss_start = .;
> >  *      BSS_SECTION(0, 0)
> >  *      __bss_end = .;
> >  *      _end = .;
> >  *
> >  *
> >  * [__init_begin, __init_end] is the init section that may be freed after init
> >  * [_stext, _etext] is the text section
> >  * [_sdata, _edata] is the data section
> >  *
> >  * Some of the included output section include their own set of constants.
> >  * Examples are: [__initramfs_start, __initramfs_end] for initramfs and
> >  *               [__nosave_begin, __nosave_end] for the nosave data
> >  */
> > 
> 
> It seems rather disturbing to me that different sections have different
> start and end symbols.  I realize this is largely for historical
> reasons, but if we used a single pattern (e.g. something like
> __text_start, __text_end for the .text section)

The 'oldish' names were kept only because they are widely used.
I agree to be consistent is better so will change it to be so.

I edited the sample above to consistently use __<section>_{begin,end}.

For now I kept '_end' as I had no better name for it.

> then at least in the
> i386 case we could easily recognize those as relocatable symbols even if
> they show up as absolute.

Do you then say that i386 could allow us to use absolute symbols,
and we could adjust in the code instead?

That would make the linker script nicer but with added
complexity in the code..

	Sam
