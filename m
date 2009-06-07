Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZFGGYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZFGGYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 02:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753506AbZFGGYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 02:24:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33660 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753217AbZFGGY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 02:24:29 -0400
Message-ID: <4A2B5D0E.20002@redhat.com>
Date: Sun, 07 Jun 2009 09:24:14 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: guillaume.thouvenin@ext.bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.30-rc8 KVM] gcc 3.3 dies at emulate_2op_cl().
References: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>
In-Reply-To: <200906050539.n555dwAQ077095@www262.sakura.ne.jp>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tetsuo Handa wrote:
> (Continued from http://lkml.org/lkml/2009/6/4/14 )
> I tried to identify the location of gcc 3.3's internal error using
> "make CONFIG_DEBUG_INFO=1 arch/x86/kvm/x86_emulate.s", and it turned out that
> the location is emulate_2op_cl().
>
> Commenting out like below solves the gcc's internal error.
>
> diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
> index ca91749..561b9b6 100644
> --- a/arch/x86/kvm/x86_emulate.c
> +++ b/arch/x86/kvm/x86_emulate.c
> @@ -2070,7 +2070,7 @@ twobyte_insn:
>                 break;
>         case 0xa4: /* shld imm8, r, r/m */
>         case 0xa5: /* shld cl, r, r/m */
> -               emulate_2op_cl("shld", c->src2, c->src, c->dst, ctxt->eflags);
> +               //emulate_2op_cl("shld", c->src2, c->src, c->dst, ctxt->eflags);
>                 break;
>         case 0xab:
>               bts:              /* bts */
> @@ -2080,7 +2080,7 @@ twobyte_insn:
>                 break;
>         case 0xac: /* shrd imm8, r, r/m */
>         case 0xad: /* shrd cl, r, r/m */
> -               emulate_2op_cl("shrd", c->src2, c->src, c->dst, ctxt->eflags);
> +               //emulate_2op_cl("shrd", c->src2, c->src, c->dst, ctxt->eflags);
>                 break;
>         case 0xae:              /* clflush */
>                 break;
>
> I think something is wrong with emulate_2op_cl() when compiled with gcc 3.3.5 .
>
>   

This is on i386, not x86_64, yes?

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

