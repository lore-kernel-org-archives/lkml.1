Return-Path: <linux-kernel-owner+w=401wt.eu-S1756983AbXE2OrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756983AbXE2OrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 10:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbXE2OrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 10:47:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59572 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbXE2OrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 10:47:05 -0400
Date: Wed, 30 May 2007 00:46:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephane Eranian <eranian@frankl.hpl.hp.com>
Cc: linux-kernel@vger.kernel.org, eranian@hpl.hp.com
Subject: Re: [PATCH 02/22] 2.6.22-rc3 perfmon2 : generic kernel
 modifications
Message-Id: <20070530004658.732451ad.sfr@canb.auug.org.au>
In-Reply-To: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com>
References: <200705291348.l4TDmG1Y019632@frankl.hpl.hp.com>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_May_2007_00_46_58_+1000_/kpN5X=40nE65iW."
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_May_2007_00_46_58_+1000_/kpN5X=40nE65iW.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On Tue, 29 May 2007 06:48:16 -0700 Stephane Eranian <eranian@frankl.hpl.hp.com> wrote:
>
> Only in linux-2.6.22/Documentation: perfmon2.txt

Did part of the patch go missing?

> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/Makefile linux-2.6.22/Makefile
> --- linux-2.6.22.base/Makefile	2007-05-29 03:17:15.000000000 -0700
> +++ linux-2.6.22/Makefile	2007-05-29 03:24:14.000000000 -0700
> @@ -553,7 +553,7 @@ export mod_strip_cmd
>
>
>  ifeq ($(KBUILD_EXTMOD),)
> -core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/
> +core-y		+= kernel/ mm/ fs/ ipc/ security/ crypto/ block/ perfmon/

This should go near the end of the patch set so that the kernel will
build at each step (if at all possible).

Seeing as what is missing below, naybe you should reorder the patch set
so that the generic changes are at the end i.e. introduce all the new
files and then wire them into the current ifrastructure.

> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/drivers/oprofile/oprofile_files.c linux-2.6.22/drivers/oprofile/oprofile_files.c
> --- linux-2.6.22.base/drivers/oprofile/oprofile_files.c	2007-05-29 03:17:41.000000000 -0700
> +++ linux-2.6.22/drivers/oprofile/oprofile_files.c	2007-05-29 03:24:14.000000000 -0700
> @@ -117,7 +117,17 @@ static ssize_t dump_write(struct file *
>  static const struct file_operations dump_fops = {
>  	.write		= dump_write,
>  };
> -
> +
> +static ssize_t implementation(struct file * file, char __user * buf, size_t count, loff_t * offset)

Break long lines at 80 characters.

> Only in linux-2.6.22/include/linux: perfmon.h
> Only in linux-2.6.22/include/linux: perfmon_dfl_smpl.h
> Only in linux-2.6.22/include/linux: perfmon_fmt.h
> Only in linux-2.6.22/include/linux: perfmon_pmu.h

Missing files?

> diff --exclude=.git -urp --exclude-from=/tmp/excl315935 linux-2.6.22.base/kernel/sched.c linux-2.6.22/kernel/sched.c
> --- linux-2.6.22.base/kernel/sched.c	2007-05-29 03:17:57.000000000 -0700
> +++ linux-2.6.22/kernel/sched.c	2007-05-29 03:24:14.000000000 -0700
> @@ -53,6 +53,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/delayacct.h>
>  #include <linux/reciprocal_div.h>
> +#include <linux/perfmon.h>

So I guess it is missing above.

> Only in linux-2.6.22: perfmon

--
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_May_2007_00_46_58_+1000_/kpN5X=40nE65iW.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGXDznFdBgD/zoJvwRAmKoAJ9G0ZBxFferqd6VjHIkwah7xPv7KACfdkWP
T29PCAso/nj0GdgtfDIWaKc=
=Av+T
-----END PGP SIGNATURE-----

--Signature=_Wed__30_May_2007_00_46_58_+1000_/kpN5X=40nE65iW.--
