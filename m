Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZIWITs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZIWITs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 04:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754392AbZIWITr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 04:19:47 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:53981 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364AbZIWITq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 04:19:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=KNve3l1rPc2edUpd9B6CF08Mkp2z3xf4BMh1AuzT2ylMCz3skstVBZfYda7aM06wFV
         liNOWMayruZawn/wuTpuAjFtcZ0b0SzgMfFMlaOy0CKOGsXGPk1Ua/khFb/HAMYw9DMv
         2gPwAwp92w+4G33Y2ZB66U7DGEdhKuhx4cqyI=
MIME-Version: 1.0
In-Reply-To: <200909220004.n8M047d1000607@imap1.linux-foundation.org>
References: <200909220004.n8M047d1000607@imap1.linux-foundation.org>
Date: Wed, 23 Sep 2009 10:19:49 +0200
X-Google-Sender-Auth: 264d49e923d677ab
Message-ID: <10f740e80909230119x612e6f4arf5a8b007702b2e7a@mail.gmail.com>
Subject: Re: [patch 158/200] m68k: convert to asm-generic/hardirq.h
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: akpm@linux-foundation.org, torvalds@linux-foundation.org, hch@lst.de
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 02:04,  <akpm@linux-foundation.org> wrote:
> From: Christoph Hellwig <hch@lst.de>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This one broke the m68k build, cfr.
http://kisskb.ellerman.id.au/kisskb/buildresult/1295096/.
I guess including <asm-generic/hardirq.h> here exposes us to Include Hell...

`git revert 45d80eea87c9f8292d2d33173d6866c0ec57238a` fixes it.

> ---
>
>  arch/m68k/include/asm/hardirq_mm.h |   12 ++----------
>  1 file changed, 2 insertions(+), 10 deletions(-)
>
> diff -puN arch/m68k/include/asm/hardirq_mm.h~m68k-convert-to-asm-generic-hardirqh arch/m68k/include/asm/hardirq_mm.h
> --- a/arch/m68k/include/asm/hardirq_mm.h~m68k-convert-to-asm-generic-hardirqh
> +++ a/arch/m68k/include/asm/hardirq_mm.h
> @@ -1,16 +1,8 @@
>  #ifndef __M68K_HARDIRQ_H
>  #define __M68K_HARDIRQ_H
>
> -#include <linux/threads.h>
> -#include <linux/cache.h>
> -
> -/* entry.S is sensitive to the offsets of these fields */
> -typedef struct {
> -       unsigned int __softirq_pending;
> -} ____cacheline_aligned irq_cpustat_t;
> -
> -#include <linux/irq_cpustat.h> /* Standard mappings for irq_cpustat_t above */
> -
>  #define HARDIRQ_BITS   8
>
> +#include <asm-generic/hardirq.h>
> +
>  #endif

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
