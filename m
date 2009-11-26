Return-Path: <linux-kernel-owner+w=401wt.eu-S1752827AbZKZV3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbZKZV3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 16:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZKZV3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 16:29:19 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:58058 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbZKZV3S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 16:29:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=OF8Uxg/tZzw6gJCwKugR7gkfg2u9mno+gLfs55qQzw7DVRRPLGy3EZOiQjO7B0ZlF4
         dohBaOd7dC/7239CRonOm6D7Ahy+KrbJ6kbsvgEYdlRNSozH63RL2OyMTawt06Ni8LrA
         rG2OwTh6cLx67AKJtYNlhqc+MShaWDFOROIi4=
MIME-Version: 1.0
In-Reply-To: <20091126115806.c53684f5.sfr@canb.auug.org.au>
References: <20091126115806.c53684f5.sfr@canb.auug.org.au>
Date: Thu, 26 Nov 2009 22:29:22 +0100
X-Google-Sender-Auth: 6465889a7690d59c
Message-ID: <10f740e80911261329s35f62au37e6b209c657e09@mail.gmail.com>
Subject: Re: linux-next: manual merge of the m68knommu tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg Ungerer <gerg@snapgear.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andreas Schwab <schwab@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 26, 2009 at 01:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Today's linux-next merge of the m68knommu tree got a conflict in
> arch/m68k/include/asm/ptrace.h between commit
> 63c361b65f6540043c4baabf1a044a45c7465858 ("m68k: use generic code for
> ptrace requests") from the m68k tree and commit
> 03a03164e8084b810e9f92906a51232d63bac72c ("m68knommu: define
> arch_has_single_step() and friends") from the m68knommu tree.
>
> These mostly add the same stuff but not quite :-(

Ah sorry, my bad. I'm not yet used to the uClinux guys touching "my"
includes ;-)
So we need better coordination between us.

IIRC, Greg's changes were inspired by Andreas' patch.

> I have done a fixup (see below) and can carry it as necessary.  Please
> check the result.

At first sight, it looks OK. Thanks for fixing it up!

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/m68k/include/asm/ptrace.h
> index eef9309,beb2091..0000000
> --- a/arch/m68k/include/asm/ptrace.h
> +++ b/arch/m68k/include/asm/ptrace.h
> @@@ -86,14 -84,15 +86,18 @@@ struct switch_stack
>  extern void show_regs(struct pt_regs *);
>
>  /*
>  - * These are defined as per linux/ptrace.h.
>  + * These are defined as per linux/ptrace.h, which see.
>   */
> + struct task_struct;
> +
>  -#ifndef CONFIG_MMU
>  -#define       arch_has_single_step()  (1)
>  +#define arch_has_single_step()        (1)
>  extern void user_enable_single_step(struct task_struct *);
>  extern void user_disable_single_step(struct task_struct *);
>  +
> ++#ifdef CONFIG_MMU
>  +#define arch_has_block_step() (1)
>  +extern void user_enable_block_step(struct task_struct *);
> + #endif
>
>  #endif /* __KERNEL__ */
>  #endif /* __ASSEMBLY__ */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
