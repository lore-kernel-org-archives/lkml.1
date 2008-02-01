Return-Path: <linux-kernel-owner+w=401wt.eu-S932313AbYBAF3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbYBAF3r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 00:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYBAF3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 00:29:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:44237 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbYBAF3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 00:29:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XjS03SBukg5qjKlzuNg5PfYHZCQeN9Xe5+IBF/CjZ03JCGArOTGES5uQ5IDPmibzMwdbXqfXsoeSGBCrlALSvSi15WJga+nZNOUHQuX+fRim4OkGPXHRiyYL9d6ejLi9MfPjqF209bB4FX6JK8U5jMjtsTiksPmUcvhOC34MbYs=
Message-ID: <29495f1d0801312129g5cc0bad1x8bdbb4a378feb1ef@mail.gmail.com>
Date: Thu, 31 Jan 2008 21:29:34 -0800
From: "Nish Aravamudan" <nish.aravamudan@gmail.com>
To: "Reinaldo Carvalho" <reinaldow@gmail.com>
Subject: Re: missing asm-x86_64 detection
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ec36785a0801311513g4172b915w7bdb7ca97035efde@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/31/08, Reinaldo Carvalho <reinaldow@gmail.com> wrote:
> :/# uname -a
> Linux devil 2.6.22.16-amd64 #15 SMP Sat Jan 19 13:58:02 BRT 2008
> x86_64 GNU/Linux
>
> :/# cd /usr/src/linux-2.6.22
> :/# patch -p1 -R < ../patch-2.6.22.16
> :/# patch -p1 < ../patch-2.6.23
> :/# patch -p1 < ../patch-2.6.24
> :/# cd /usr/src/ ; mv linux-2.6.22 linux-2.6.24; cd linux-2.6.24
> :/usr/src/linux-2.6.24# make oldconfig
> :/usr/src/linux-2.6.24# make all
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
> ERROR: the symlink include/asm points to asm-x86_64 but asm-x86 was expected
>        set ARCH or save .config and run 'make mrproper' to fix it
> make: ** [include/asm] Erro 1
>
> :/usr/src/linux-2.6.24# cp .config ../config-2.6.24
> :/usr/src/linux-2.6.24# make mrproper
>   CLEAN   scripts/basic
>   CLEAN   scripts/genksyms
>   CLEAN   scripts/kconfig
>   CLEAN   scripts/mod
>   CLEAN   scripts
>   CLEAN   include/config
>   CLEAN   .config .config.old include/asm .version
> include/linux/autoconf.h include/linux/version.h
> include/linux/utsrelease.h Module.symvers
> devil:/usr/src/linux-2.6.24# cp ../config-2.6.24 .config
> devil:/usr/src/linux-2.6.24# make oldconfig
> devil:/usr/src/linux-2.6.24# make all
> scripts/kconfig/conf -s arch/x86/Kconfig
>   CHK     include/linux/version.h
>   UPD     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   UPD     include/linux/utsrelease.h
>   SYMLINK include/asm -> include/asm-x86
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/asm-x86/asm-offsets.h
> ...
>
> system is x86_64!

And your point? The archs are being merged into just x86 (instead of
x86_32 and x86_64 being separate). That's why the asm-x86_64 symlink
was complained about above.

There is no error. Check your config that CONFIG_64BIT and
CONFIG_X86_64 are set.

Thanks,
Nish
