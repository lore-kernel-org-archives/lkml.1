Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740Ab0AABRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab0AABRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 20:17:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751374Ab0AABRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 20:17:06 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:56113 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0AABRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 20:17:04 -0500
Date: Thu, 31 Dec 2009 17:16:59 -0800
From: Jun Sun <jsun@junsun.net>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Subject: Re: [PATCH] Valid relocation symbol for FLAT format on ARM
Message-ID: <20100101011659.GA16887@Pogoplug>
References: <20091226163600.GA16091@Pogoplug> <8bd0f97a0912311052o160beeccl77282950a6b56367@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0f97a0912311052o160beeccl77282950a6b56367@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 01:52:08PM -0500, Mike Frysinger wrote:
> On Sat, Dec 26, 2009 at 11:36, Jun Sun wrote:
> > Apparently newer GCC would generate ANCHOR symbols beyond the end of
> > data/bss segment on ARM CPUs. As a result, the exiting validity checking
> > for relocation symbols in FLAT format will fail.
> >
> > This also fixes a cosmetic error in printk. Text segment and data/bss
> > segment are allocated from two different areas. It is not meaningful to
> > give the diff between them in error reporting messages.
> >
> > Signed-off-by: Jun Sun <jsun@junsun.net>
> >
> > diff -Nru linux-2.6.32.2/arch/arm/include/asm/flat.h.orig linux-2.6.32.2/arch/arm/include/asm/flat.h
> 
> you really should use git to generate the patch.  if you're going to
> do it by hand, you need to format it correctly.  you're missing the
> --- marker between your change log and the start of the patch.
> 
> > --- linux-2.6.32.2/fs/binfmt_flat.c
> > +++ linux-2.6.32.2/fs/binfmt_flat.c
> > @@ -355,7 +355,7 @@
> >
> > ?? ?? ?? ??if (!flat_reloc_valid(r, start_brk - start_data + text_len)) {
> > ?? ?? ?? ?? ?? ?? ?? ??printk("BINFMT_FLAT: reloc outside program 0x%x (0 - 0x%x/0x%x)",
> > - ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??(int) r,(int)(start_brk-start_code),(int)text_len);
> > + ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??(int) r,(int)(start_brk-start_data+text_len),(int)text_len);
> > ?? ?? ?? ?? ?? ?? ?? ??goto failed;
> > ?? ?? ?? ??}
> 
> this should be a separate patch since it is unrelated to your other change
> -mike

Thanks for the feedback. Have not submitted any patches for a while.
New patches are coming in a sec.

Cheers.

Jun
