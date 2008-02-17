Return-Path: <linux-kernel-owner+w=401wt.eu-S1761432AbYBQMdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761432AbYBQMdA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760925AbYBQMbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:31:20 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:52076 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760917AbYBQMbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:31:17 -0500
Date: Sun, 17 Feb 2008 13:31:14 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: setup_usemap() must be __meminit
In-Reply-To: <Pine.LNX.4.64.0802171317230.10451@anakin>
Message-ID: <Pine.LNX.4.64.0802171329400.6172@anakin>
References: <Pine.LNX.4.64.0802171317230.10451@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Feb 2008, Geert Uytterhoeven wrote:
> On m68k (CONFIG_SPARSEMEM is not set), I get:
> 
>     WARNING: vmlinux.o(.meminit.text+0x36c): Section mismatch in reference from the function free_area_init_core() to the function .init.text:setup_usemap()
>     The function __meminit free_area_init_core() references
>     a function __init setup_usemap().
>     If free_area_init_core is only used by setup_usemap then
>     annotate free_area_init_core with a matching annotation.
> 
> If CONFIG_SPARSEMEM is set, the problem is  not noticed because setup_usemap()
> is always inlined.
> 
> Properly annotating setup_usemap() and usemap_size() fixes it.

Woops, hit the send button too soon.

setup_usemap() calls alloc_bootmem_node(), causing a whole new
avalanche of warnings to be fixed up :-(

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
