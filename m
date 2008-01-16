Return-Path: <linux-kernel-owner+w=401wt.eu-S1757331AbYAPC0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331AbYAPC0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 21:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYAPCZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 21:25:52 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:11040 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYAPCZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 21:25:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=eqqfyQlBWLnh5QlYdQIayKzWxfSMlHDSzpHaGn6XiQKo1/IhF7+I8I684KNgFFIk2DFaOHmtoLKzqcoCwffS2NXlJkrbUOp5gAkIDwhrl77SLx3virzT0mRNghTLKtqUmSLKGNIiq9kARmYPd2M5Ct09NKxcq5T1BKbGFxT+byI=
Message-ID: <386072610801151825ie5df817ldfb5e333ccd70db5@mail.gmail.com>
Date: Wed, 16 Jan 2008 10:25:50 +0800
From: "Bryan Wu" <cooloney.lkml@gmail.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: Fix Blackfin HARDWARE_PM support
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <adrian.bunk@movial.fi>,
       "Randy Dunlap" <randy.dunlap@oracle.com>, bryan.wu@analog.com,
       "Robin Getz" <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080115174202.GD8375@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115174202.GD8375@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 1:42 AM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> This patch restores the blackfin Hardware Performance Monitor Profiling
> support that was killed by
> commit 09cadedbdc01f1a4bea1f427d4fb4642eaa19da9.
>
> Since there seems to be no good reason to behave differently from other
> architectures, it now automatically selects the hardware performance counters
> whenever the profiling is activated.
>
> mach-common/irqpanic.c: pm_overflow
> calls pm_overflow_handler which is in oprofile/op_model_bf533.c. I doubt that
> setting HARDWARE_PM as "m" will work at all, since the pm_overflow_handler
> should be in the core kernel image because it is called by irqpanic.c.
>
> Therefore, I change HARDWARE_PM from a tristate to a bool.
>
> The whole arch/$(ARCH)/oprofile/ is built depending on CONFIG_OPROFILE. Since
> part of the HARDWARE_PM support files sits in this directory, it makes sense to
> also depend on OPROFILE, not only PROFILING. Since OPROFILE already depends on
> PROFILING, it is correct to only depend on OPROFILE only.
>
> Thanks to Adrian Bunk for finding this bug and providing an initial
> patch.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Adrian Bunk <adrian.bunk@movial.fi>
> CC: Randy Dunlap <randy.dunlap@oracle.com>
> CC: bryan.wu@analog.com
> CC: Robin Getz <rgetz@blackfin.uclinux.org>
> ---

Thanks, finally we got this.

Acked-by: Bryan Wu <bryan.wu@analog.com>

>  arch/blackfin/Kconfig |    4 ++++
>  1 file changed, 4 insertions(+)
>
> Index: linux-2.6-lttng/arch/blackfin/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/arch/blackfin/Kconfig  2007-12-29 11:00:05.000000000 -0500
> +++ linux-2.6-lttng/arch/blackfin/Kconfig       2007-12-29 11:25:39.000000000 -0500
> @@ -65,6 +65,10 @@ config GENERIC_CALIBRATE_DELAY
>         bool
>         default y
>
> +config HARDWARE_PM
> +       def_bool y
> +       depends on OPROFILE
> +
>  source "init/Kconfig"
>  source "kernel/Kconfig.preempt"
>
>
>
> --
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
