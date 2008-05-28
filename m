Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbYE1WXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbYE1WXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbYE1WXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 18:23:04 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:50118 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbYE1WXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 18:23:03 -0400
Date: Wed, 28 May 2008 23:20:42 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Willy Tarreau <w@1wt.eu>
cc: Jan Engelhardt <jengelh@medozas.de>, Fede <fedux@lugmen.org.ar>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] Re: bad pmd ffff810000207238(9090909090909090).
In-Reply-To: <20080528204356.GA12687@1wt.eu>
Message-ID: <Pine.LNX.4.64.0805282307520.29949@blonde.site>
References: <483CBCDD.10401@lugmen.org.ar> <Pine.LNX.4.64.0805281922530.7959@blonde.site>
 <20080528195637.GA11662@1wt.eu> <alpine.LNX.1.10.0805282210580.19264@fbirervta.pbzchgretzou.qr>
 <20080528204356.GA12687@1wt.eu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2008, Willy Tarreau wrote:
> On Wed, May 28, 2008 at 10:14:31PM +0200, Jan Engelhardt wrote:
> > On Wednesday 2008-05-28 21:56, Willy Tarreau wrote:
> > >On Wed, May 28, 2008 at 07:36:07PM +0100, Hugh Dickins wrote:
> > >> 
> > >> page on my x86_64 boxes, and they have lots of 0x90s there too.
> > >> It's just some page alignment filler that x86_64 kernel startup
> > >> has missed cleaning up - patch below fixes that.  There's no
> > >
> > >Is there a particular reason we use 0x90 as an alignment filler ?
> > 
> > Alignment within functions. You could use a JMP to jump over
> > the alignment, but that would be costly. So in order to
> > "run through the wall", you need an opcode that does not
> > do anything, something like 0x90.
> 
> OK, I did not understand from Hugh's explanation that it was
> all about alignment within functions. Of course, 0x90 is fine
> there (though there are multi-byte NOPs available).

I'm hardly the right person to answer on this, but I believe that
because the 0x90 NOP is particularly appropriate in .text (and
prevents stalls even where it cannot be reached?), it gets used
as the default alignment filler all over.   (It's even specified
for the arch-independent default _ALIGN in linux/linkage.h.)

Hugh
