Return-Path: <linux-kernel-owner+w=401wt.eu-S1755022AbYKORZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022AbYKORZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 12:25:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751736AbYKORZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 12:25:51 -0500
Received: from ti-out-0910.google.com ([209.85.142.184]:44327 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYKORZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 12:25:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wkZVqaEzZSKL49UiFqn9WwYzlfkIGpwjtl5Cozz9o5AcnHPsq5xrf0VosSSDJPRHEB
         5eWQwBiuD6IHa+1TdPgVuM6QMsSjcLDsstZEo0/HuV/86/GHYa0Gclheyp+NdtPAaVFq
         /xNO26DEN/DTw2IOWLvQbDeEPCPejCdWhewxM=
Message-ID: <2375c9f90811150925l2aebbdfejed8725f15a801e1d@mail.gmail.com>
Date: Sat, 15 Nov 2008 17:25:49 +0000
From: "=?UTF-8?Q?Am=C3=A9rico_Wang?=" <xiyou.wangcong@gmail.com>
To: "Hiroshi Shimamoto" <h-shimamoto@ct.jp.nec.com>
Subject: Re: [PATCH 5/5] x86: ia32_signal: change order of storing in setup_sigcontext()
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <491E41F2.4030403@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491E4101.7010405@ct.jp.nec.com> <491E41F2.4030403@ct.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 15, 2008 at 3:28 AM, Hiroshi Shimamoto
<h-shimamoto@ct.jp.nec.com> wrote:
> From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
>
> Impact: cleanup
>
> Change order of storing to match the sigcontext_ia32.


Well, more than reordering... Please see below.

>
> Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
> ---
>  arch/x86/ia32/ia32_signal.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
> index 2883f41..909181a 100644
> --- a/arch/x86/ia32/ia32_signal.c
> +++ b/arch/x86/ia32/ia32_signal.c
> @@ -360,13 +360,13 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
>        err |= __put_user(regs->dx, &sc->dx);
>        err |= __put_user(regs->cx, &sc->cx);
>        err |= __put_user(regs->ax, &sc->ax);
> -       err |= __put_user(regs->cs, &sc->cs);
> -       err |= __put_user(regs->ss, &sc->ss);
>        err |= __put_user(current->thread.trap_no, &sc->trapno);
>        err |= __put_user(current->thread.error_code, &sc->err);
>        err |= __put_user(regs->ip, &sc->ip);
> +       err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
>        err |= __put_user(regs->flags, &sc->flags);
>        err |= __put_user(regs->sp, &sc->sp_at_signal);
> +       err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);


Why do you add two casts? If these two are necessary, I am afraid the rest ones
also need. :)
