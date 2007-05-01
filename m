Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbXEAQbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbXEAQbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 12:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754538AbXEAQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 12:31:11 -0400
Received: from hoboe2bl1.telenet-ops.be ([195.130.137.73]:44493 "EHLO
	hoboe2bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754537AbXEAQbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 12:31:10 -0400
Date: Tue, 1 May 2007 18:31:07 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [AF_RXRPC]: Make the in-kernel AFS filesystem use AF_RXRPC. 
In-Reply-To: <9374.1178036083@redhat.com>
Message-ID: <Pine.LNX.4.64.0705011820180.27246@anakin>
References: <Pine.LNX.4.64.0705011734410.27246@anakin>
 <200704271707.l3RH7H5Z032671@hera.kernel.org>  <9374.1178036083@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 May 2007, David Howells wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > This causes a compile failure on m68k:
> 
> Hmmm... I couldn't actually test m68k as I couldn't get it to compile.  Can
> you give me a good config I can use as a base?
> 
> > | linux/fs/afs/fsclient.c: In function 'afs_deliver_fs_fetch_data':
> > | linux/fs/afs/fsclient.c:269: warning: dereferencing 'void *' pointer
> > | linux/fs/afs/fsclient.c:269: error: request for member 'virtual' in something not a structure or union
> 
> Ummm...  Maybe m68k kmap_atomic() should cast it...  I think everywhere else
> it must be an inline function or something.

On architectures that #define WANT_PAGE_VIRTUAL (frv/m68k/mips/extensa),
page_address(page) expands to (page)->virtual, which fails if page is a
void *.

> However, I'll subsume your patch into mine if you don't mind.

Please apply ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
