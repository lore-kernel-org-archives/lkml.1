Return-Path: <linux-kernel-owner+w=401wt.eu-S1760988AbYDXTlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760988AbYDXTlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 15:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763355AbYDXTkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 15:40:21 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:49290 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbYDXTkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 15:40:18 -0400
Date: Thu, 24 Apr 2008 21:40:15 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Hellwig <hch@infradead.org>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       xfs@oss.sgi.com
Subject: Re: linux-next: Tree for April 24
In-Reply-To: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0804242136420.21224@anakin>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Apr 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

For the second day in a row, m68k builds failed because of

    fs/xfs/xfs_fsops.c:527: error: implicit declaration of function 'xfs_icsb_sync_counters_locked'
    make[3]: *** [fs/xfs/xfs_fsops.o] Error 1

According to
http://www.linux.sgi.com/archives/xfs/2008-03/msg00202.html, there's a
forward declaration for xfs_icsb_sync_counters_locked() only if HAVE_PERCPU_SB
is defined, i.e. for CONFIG_SMP. This break UP architectures.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
