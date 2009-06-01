Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZFATza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZFATza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 15:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZFATzW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 15:55:22 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:56355 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755482AbZFATzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 15:55:21 -0400
MIME-Version: 1.0
In-Reply-To: <200905302137.57644.bzolnier@gmail.com>
References: <20090529145018.ff547ea1.sfr@canb.auug.org.au>
	 <200905302137.57644.bzolnier@gmail.com>
Date: Mon, 1 Jun 2009 15:55:22 -0400
Message-ID: <7e0fb38c0906011255o25f2e852r6ba469c8345e8c77@mail.gmail.com>
Subject: Re: linux-next: Tree for May 29 (__rdmsr_on_cpu() OOPS)
From: Eric Paris <eparis@parisplace.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Borislav Petkov <borislav.petkov@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 3:37 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:

> [ Borislav, feel free to fold it into the above change or replace by
>  a more complete one if needed (there may be more rv fields needing
>  initialization). ]
>
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] x86: MSR: fix __rdmsr_on_cpu() OOPS
>
> {rd,wr}msr_on_cpu() need to explicitly initalize rv.msrs
> (since rv is allocated on the stack).
>
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Still broken in 0601, none of my systems will even boot without this patch.

Tested-by: Eric Paris <eparis@redhat.com>

> ---
>  arch/x86/lib/msr.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: b/arch/x86/lib/msr.c
> ===================================================================
> --- a/arch/x86/lib/msr.c
> +++ b/arch/x86/lib/msr.c
> @@ -44,6 +44,7 @@ int rdmsr_on_cpu(unsigned int cpu, u32 m
>        int err;
>        struct msr_info rv;
>
> +       rv.msrs   = NULL;
>        rv.msr_no = msr_no;
>        err = smp_call_function_single(cpu, __rdmsr_on_cpu, &rv, 1);
>        *l = rv.reg.l;
> @@ -58,6 +59,7 @@ int wrmsr_on_cpu(unsigned int cpu, u32 m
>        int err;
>        struct msr_info rv;
>
> +       rv.msrs   = NULL;
>        rv.msr_no = msr_no;
>        rv.reg.l = l;
>        rv.reg.h = h;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
