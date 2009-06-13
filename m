Return-Path: <linux-kernel-owner+w=401wt.eu-S1761287AbZFMNxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287AbZFMNxx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 09:53:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755421AbZFMNxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 09:53:48 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:38128 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbZFMNxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 09:53:47 -0400
Date: Sat, 13 Jun 2009 15:56:04 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Marco <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Daniel Walker <dwalker@soe.ucsc.edu>
Subject: Re: [PATCH 08/14] Pramfs: Makefile and Kconfig
Message-ID: <20090613135604.GB30053@uranus.ravnborg.org>
References: <4A33A802.8040507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A33A802.8040507@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +
> +config PRAMFS_NOWP
> +	bool "Disable PRAMFS write protection"
> +	depends on PRAMFS
> +	default n
> +	help
> +	   Say Y here to disable the write protect feature of PRAMFS.
n is default so "default n" is not needed.
If you reverse the logic (and add a default y) then..

> +ifneq ($(CONFIG_PRAMFS_NOWP),y)
> +pramfs-objs += wprotect.o
> +endif
This is a trivial:
pramfs-$(PRAMFS_WRITE_PROTECT) += wprotect.o

(I renamed the option to something more descriptive - please do so in the abvoe).


> +++ linux-2.6.30/fs/pramfs/Makefile	2009-04-19 11:58:51.000000000 +0200
> @@ -0,0 +1,13 @@
> +#
> +# Makefile for the linux pram-filesystem routines.
> +#
> +
> +obj-$(CONFIG_PRAMFS) += pramfs.o
> +obj-$(CONFIG_TEST_MODULE) += pramfs_test.o
> +
> +pramfs-objs := balloc.o dir.o file.o inode.o namei.o super.o symlink.o

Use:
pramfs-y := balloc.o ...

This match usa later in this file.

> +
> +ifneq ($(CONFIG_PRAMFS_NOWP),y)
> +pramfs-objs += wprotect.o
> +endif
> +pramfs-$(CONFIG_PRAMFS_XIP) += xip.o


	Sam
