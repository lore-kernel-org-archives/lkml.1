Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXJVTjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXJVTjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbXJVTjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:39:45 -0400
Received: from hoboe1bl1.telenet-ops.be ([195.130.137.72]:48921 "EHLO
	hoboe1bl1.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbXJVTjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:39:44 -0400
Date: Mon, 22 Oct 2007 21:39:39 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
In-Reply-To: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
Message-ID: <Pine.LNX.4.64.0710222137520.7105@anakin>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
 <1193076664-13652-10-git-send-email-jens.axboe@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007, Jens Axboe wrote:
> Change the page member of the scatterlist structure to be an unsigned
> long, and encode more stuff in the lower bits:
> 
> - Bits 0 and 1 zero: this is a normal sg entry. Next sg entry is located
>   at sg + 1.
> - Bit 0 set: this is a chain entry, the next real entry is at ->page_link
>   with the two low bits masked off.
> - Bit 1 set: this is the final entry in the sg entry. sg_next() will return
>   NULL when passed such an entry.

Better safe than sorry...

Is it possible that a chain entry pointer has bit 1 set on architectures
(e.g. m68k) where the natural alignment of 32-bit quantities is _2_ bytes,
not 4?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
