Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbXK1JYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbXK1JYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 04:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbXK1JYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 04:24:09 -0500
Received: from asia.telenet-ops.be ([195.130.137.74]:56908 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbXK1JYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 04:24:08 -0500
Date: Wed, 28 Nov 2007 10:24:02 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: m68k build failure
In-Reply-To: <20071128094856.056c0a3f@poseidon.drzeus.cx>
Message-ID: <Pine.LNX.4.64.0711281020350.29243@anakin>
References: <20071127220723.e2e3d0b4.akpm@linux-foundation.org>
 <20071128094856.056c0a3f@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Pierre Ossman wrote:
> On Tue, 27 Nov 2007 22:07:23 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> > Current Linus tree give me this, with m68k allmodconfig:
> > 
> > FATAL: drivers/bluetooth/btsdio: sizeof(struct sdio_device_id)=12 is not a modulo of the size of section __mod_sdio_device_table=30.
> > Fix definition of struct sdio_device_id in mod_devicetable.h
> > 
> > which I haven't seen before.  Any ideas?
> 
> No the slightest. 12 seems like the correct, padded size. A size of 10 is just weird as the unpadded size is 9 bytes. Could you dump the __mod_sdio_device_table section so we can determine if it is cropped or just oddly padded.

10 is correct. On m68k, the natural alignment of quantities larger than
one byte is 2 bytes, not 4 bytes.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
