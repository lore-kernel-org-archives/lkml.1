Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbZLOH7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbZLOH7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 02:59:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZLOH7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 02:59:05 -0500
Received: from mail-qy0-f192.google.com ([209.85.221.192]:61858 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbZLOH7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 02:59:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=D1qUVsiWpjbdo8woWoTyPAobfWsOyh+2/nensUin0l408gnmQyK7iR9h2YlVzjYOTs
         oPQGiRMJQRvbf/032PB7WKhS09h45jhLSH949aChMDhXnw1IHGRNDuCzwU57BUCUooyH
         rcpXxZcUV/nEze9IF4dNWw5Af+oqlrtFvaD9s=
MIME-Version: 1.0
In-Reply-To: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
References: <20091215.114118.226800461.d.hatayama@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 15:58:58 +0800
Message-ID: <2375c9f90912142358j24cc1bf8p2f696f56537befc6@mail.gmail.com>
Subject: Re: [RFC, PATCH 1/4] cleanup elf_core_dump(): remove ELF_CORE_EXTRA_* 
	macro
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, jdike@addtoit.com,
       tony.luck@intel.com, mhiramat@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 10:41 AM, Daisuke HATAYAMA
<d.hatayama@jp.fujitsu.com> wrote:
> elf_core_dump() uses #ifdef and the corresponding macro for hiding
> _multiline_ logics in functions. This patch removes #ifdef and
> replaces ELF_CORE_EXTRA_* by corresponding functions. For
> architectures not implemeonting ELF_CORE_EXTRA_*, we use weak
> functions in order to reduce a range of modification.
>
> This cleanup is for my next patches, but I think this cleanup itself
> is worth doing regardless of my firnal purpose.
>
> Signed-off-by: Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>


Good patch! I like it!

Just one problem below.


> --- /dev/null
> +++ b/arch/um/sys-i386/elfcore.c
> @@ -0,0 +1,78 @@
> +#include <linux/elf.h>
> +#include <linux/fs.h>
> +#include <linux/mm.h>
> +
> +#include <asm/elf.h>
> +
> +static int dump_write(struct file *file, const void *addr, int nr)
> +{
> +       return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
> +}

We already have the same dump_write() in fs/binfmt_elf.c, can't we
reuse it? e.g. moving it to a header and make it staic inline.

Thanks!
