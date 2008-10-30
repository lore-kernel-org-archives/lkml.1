Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbYJ3VVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbYJ3VVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 17:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbYJ3VVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 17:21:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:17417 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYJ3VVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 17:21:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ZaX8yk4bgIU/rBUEMKa6ZWVydXTqhFsY++9tmbabEBmXXzny1cLC1tdN3o/Ysaq71K
         nI2/VJgH+XlgRaMbntJhdwAjrDlFoN7IxAV95EieZmKgl5ny3q/KTTs8pLdM+se11Amx
         6fkaOmO2fO9nDxqh+jnAvYBJ5aA1bVE1y+r6o=
Message-ID: <86802c440810301421t71e88ffm112a7bd361e7920a@mail.gmail.com>
Date: Thu, 30 Oct 2008 14:21:20 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "James Bottomley" <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH] x86: fix missing cpu_index initialisation
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1225401217.19324.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1225401217.19324.28.camel@localhost.localdomain>
X-Google-Sender-Auth: 427fc7dd46ce437c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 2:13 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> >From f49bbb826d8ec87609a63fb014af6aacb16aac38 Mon Sep 17 00:00:00 2001
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> Date: Wed, 29 Oct 2008 15:13:09 -0500
> Subject: [VOYAGER] x86: fix missing cpu_index initialisation
>
> Ever since
>
> commit 92cb7612aee39642d109b8d935ad265e602c0563
> Author: Mike Travis <travis@sgi.com>
> Date:   Fri Oct 19 20:35:04 2007 +0200
>
>    x86: convert cpuinfo_x86 array to a per_cpu array
>
> We've had an extra field in cpuinfo_x86 which is cpu_index.
> Unfortunately, voyager has never initialised this, although the only
> noticeable impact seems to be that /proc/cpuinfo shows all zeros for
> the processor ids.
>
> Anyway, fix this by initialising the boot CPU properly and setting the
> index when the secondaries update.
>
> Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> ---
>
> Depends on [VOYAGER] x86: add ability to test for boot CPU
>
>  arch/x86/kernel/cpu/common.c        |    2 ++
>  arch/x86/mach-voyager/voyager_smp.c |    1 +
>  2 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 93e9393..da8f15a 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -549,6 +549,8 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
>                this_cpu->c_early_init(c);
>
>        validate_pat_support(c);
> +
> +       c->cpu_index = boot_cpu_id;
>  }
...
  CC      arch/x86/kernel/cpu/common.o
arch/x86/kernel/cpu/common.c: In function 'early_identify_cpu':
arch/x86/kernel/cpu/common.c:553: error: 'boot_cpu_id' undeclared
(first use in this function)
arch/x86/kernel/cpu/common.c:553: error: (Each undeclared identifier
is reported only once
arch/x86/kernel/cpu/common.c:553: error: for each function it appears in.)
make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
make[1]: *** [arch/x86/kernel/cpu] Error 2
make: *** [arch/x86/kernel] Error 2

YH
