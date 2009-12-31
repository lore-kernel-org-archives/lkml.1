Return-Path: <linux-kernel-owner+w=401wt.eu-S1753080AbZLaSwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080AbZLaSwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 13:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZLaSwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 13:52:32 -0500
Received: from mail-yw0-f176.google.com ([209.85.211.176]:52197 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033AbZLaSwb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 13:52:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=dw/r4s0oWa6EpjNIxtGf114w0EHy1Q1bz1H50n0PVIouUyZZUKBmAARpfvMgOdYiEg
         5482HBtGuJK5hHzdU1z3h4T/HwxV+rVMDVYTCtV2OsIgkFr4/+41toWDq3ZGgMQSho4z
         5Ii1pfWJ/oiKnmrsS/KR6AqISgLABKs7/4t6o=
MIME-Version: 1.0
In-Reply-To: <20091226163600.GA16091@Pogoplug>
References: <20091226163600.GA16091@Pogoplug>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 31 Dec 2009 13:52:08 -0500
Message-ID: <8bd0f97a0912311052o160beeccl77282950a6b56367@mail.gmail.com>
Subject: Re: [PATCH] Valid relocation symbol for FLAT format on ARM
To: Jun Sun <jsun@junsun.net>
Cc: linux-kernel@vger.kernel.org, uclinux-dev@uclinux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 11:36, Jun Sun wrote:
> Apparently newer GCC would generate ANCHOR symbols beyond the end of
> data/bss segment on ARM CPUs. As a result, the exiting validity checking
> for relocation symbols in FLAT format will fail.
>
> This also fixes a cosmetic error in printk. Text segment and data/bss
> segment are allocated from two different areas. It is not meaningful to
> give the diff between them in error reporting messages.
>
> Signed-off-by: Jun Sun <jsun@junsun.net>
>
> diff -Nru linux-2.6.32.2/arch/arm/include/asm/flat.h.orig linux-2.6.32.2/arch/arm/include/asm/flat.h

you really should use git to generate the patch.  if you're going to
do it by hand, you need to format it correctly.  you're missing the
--- marker between your change log and the start of the patch.

> --- linux-2.6.32.2/fs/binfmt_flat.c
> +++ linux-2.6.32.2/fs/binfmt_flat.c
> @@ -355,7 +355,7 @@
>
>        if (!flat_reloc_valid(r, start_brk - start_data + text_len)) {
>                printk("BINFMT_FLAT: reloc outside program 0x%x (0 - 0x%x/0x%x)",
> -                      (int) r,(int)(start_brk-start_code),(int)text_len);
> +                      (int) r,(int)(start_brk-start_data+text_len),(int)text_len);
>                goto failed;
>        }

this should be a separate patch since it is unrelated to your other change
-mike
