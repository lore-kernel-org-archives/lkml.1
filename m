Return-Path: <linux-kernel-owner+w=401wt.eu-S1757717AbYAEUSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757717AbYAEUSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 15:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757837AbYAEUR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 15:17:29 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:39791 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757825AbYAEUR2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 15:17:28 -0500
Date: Sat, 5 Jan 2008 21:17:28 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [RFC] [PATCH 2/3] Rework arch specific Makefiles to use mkimage
Message-ID: <20080105201728.GA9985@uranus.ravnborg.org>
References: <20071220101643.48b427ef@zod.rchland.ibm.com> <20071220101829.44ca59da@zod.rchland.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071220101829.44ca59da@zod.rchland.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 10:18:29AM -0600, Josh Boyer wrote:
> Rework the architecture specific Makefiles to use the in-kernel version
> of the mkimage tool.
> 
> Signed-off-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>
> 
> ---
>  arch/arm/boot/Makefile          |    4 ++--
>  arch/avr32/boot/images/Makefile |    4 ++--
>  arch/blackfin/boot/Makefile     |    4 ++--
>  arch/powerpc/boot/Makefile      |    8 ++++++--
>  arch/powerpc/boot/wrapper       |    2 +-
>  arch/ppc/boot/images/Makefile   |    4 ++--
>  arch/sh/boot/Makefile           |    4 ++--
>  7 files changed, 17 insertions(+), 13 deletions(-)
> 
> --- linux-2.6.orig/arch/arm/boot/Makefile
> +++ linux-2.6/arch/arm/boot/Makefile
> @@ -11,7 +11,7 @@
>  # Copyright (C) 1995-2002 Russell King
>  #
>  
> -MKIMAGE         := $(srctree)/scripts/mkuboot.sh
> +MKIMAGE         := $(srctree)/scripts/mkimage/mkimage
I did s/srctree/objtree/ for all these assignments - as mkimage
is a generated file which is not present in $(srctree) for
make O=... builds.

	Sam
