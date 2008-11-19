Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYKSIWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYKSIWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:22:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYKSIWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:22:09 -0500
Received: from harold.telenet-ops.be ([195.130.133.65]:45761 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbYKSIWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:22:08 -0500
Date: Wed, 19 Nov 2008 09:21:48 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mm-commits@vger.kernel.org, harvey.harrison@gmail.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, bryan.wu@analog.com,
       "David S. Miller" <davem@davemloft.net>, dhowells@redhat.com,
       Greg Ungerer <gerg@uclinux.org>, grundler@parisc-linux.org,
       heiko.carstens@de.ibm.com, hskinnemoen@atmel.com,
       ink@jurassic.park.msu.ru, kyle@mcmartin.ca, lethal@linux-sh.org,
       linux-arch@vger.kernel.org, mingo@elte.hu,
       Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
       Russell King <rmk@arm.linux.org.uk>, rth@twiddle.net,
       schwidefsky@de.ibm.com, takata@linux-m32r.org, tglx@linutronix.de,
       tony.luck@intel.com, ysato@users.sourceforge.jp, zankel@tensilica.com,
       Roman Zippel <zippel@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: + unaligned-introduce-common-header.patch added to -mm tree
In-Reply-To: <200811190614.mAJ6EsXA007330@imap1.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811190919280.27671@anakin>
References: <200811190614.mAJ6EsXA007330@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2008, akpm@linux-foundation.org wrote:
> Subject: unaligned: introduce common header
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> There are two common cases in the kernel, one where unaligned access is OK
> for an arch and one where the arch uses a packed-struct for the native
> endianness and opencoded C byteshifting for the other endianness. 
> Consolidate these two implementations in asm-generic/unaligned.h
> 
> Arches that require no special handling of unaligned access can define
> _UNALIGNED_ACCESS_OK in their asm/unaligned.h before including the generic
> version.
> 
> +static inline void __put_le32_noalign(u8 *p, u32 val)
> +{
> +	__put_le16_noalign(p + 2, val >> 16);
> +	__put_le16_noalign(p, val);

Isn't it more logical to reverse the order, to store in increasing memory
locations:

	__put_le16_noalign(p, val);
	__put_le16_noalign(p + 2, val >> 16);

> +}
> +
> +static inline void __put_le64_noalign(u8 *p, u64 val)
> +{
> +	__put_le32_noalign(p + 4, val >> 32);
> +	__put_le32_noalign(p, val);

Same here:

	__put_le32_noalign(p, val);
	__put_le32_noalign(p + 4, val >> 32);

> +}

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
