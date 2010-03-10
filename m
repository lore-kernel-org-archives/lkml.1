Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0CJLDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 06:03:43 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33119 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab0CJLDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 06:03:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type;
        b=qxI8iNbp86PtoDw4Ovndt1VssqopDwVrGAVOJ86K3kH8uog9JwY6LLpV2pBivh8T/b
         UXCTKPBe/QCcw7oMgcO17heCgAKxU4gF6WO4LVUtRHlJ0cRM8UhNXoqTmdni2dfC00r7
         ZxnCW2lhDWoeQ0UL7ijLkPRmaZVkw1+182ey8=
MIME-Version: 1.0
Date: Wed, 10 Mar 2010 12:03:37 +0100
X-Google-Sender-Auth: fff3c577cc2887e6
Message-ID: <10f740e81003100303m5a4ffb45t26c380b4ef3dec37@mail.gmail.com>
Subject: DMA_ERROR_CODE (was: Re: linux-next: build failure after merge of the 
	final tree)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 10:40, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
>
> drivers/mtd/nand/r852.c:22: error: 'enable_dma' redeclared as different kind of symbol
> arch/powerpc/include/asm/dma.h:189: note: previous definition of 'enable_dma' was here
> drivers/mtd/nand/r852.c: In function 'r852_engine_enable':
> drivers/mtd/nand/r852.c:545: error: implicit declaration of function 'msleep'
>
> Caused by commit 67e054e919248fa1db93de727fb9ad49eb700642 ("mtd: nand:
> Add driver for Ricoh xD/SmartMedia reader") from the mtd.
>
> I applied the following patch for today.
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 1 Mar 2010 20:21:06 +1100
> Subject: [PATCH] mtd: nand: fix name space clash
>
> and include delay.h for msleep().

Another issue is that this driver uses DMA_ERROR_CODE, which is currently
defined on powerpc/sparc/x86 only.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
