Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbXFOKF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbXFOKF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 06:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbXFOKFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 06:05:14 -0400
Received: from aun.it.uu.se ([130.238.12.36]:38710 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbXFOKFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 06:05:13 -0400
Date: Fri, 15 Jun 2007 12:03:57 +0200 (MEST)
Message-Id: <200706151003.l5FA3vd6008194@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, vtaras@openvz.org
Subject: Re: [PATCH] diskquota: 32bit quota tools on 64bit architectures
Cc: dev@sw.ru, devel@openvz.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       nataliep@google.com, vvs@sw.ru
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007 13:01:48 +0400, Vasily Tarasov wrote:
> OpenVZ Linux kernel team has discovered the problem 
> with 32bit quota tools working on 64bit architectures.
> In 2.6.10 kernel sys32_quotactl() function was replaced by sys_quotactl() with
> the comment "sys_quotactl seems to be 32/64bit clean, enable it for 32bit"
> However this isn't right. Look at if_dqblk structure:

Your patch only converts ia32 on x86-64 or ia64.
What about ppc32-on-ppc64 and sparc32-on-sparc64?
And, I guess, mips32-on-mips64?

> --- linux-2.6.22-rc4-fixed/fs/quota.c.orig	2007-06-14 15:55:26.000000000 +0400
> +++ linux-2.6.22-rc4-fixed/fs/quota.c	2007-06-14 19:50:13.000000000 +0400
...
> +#if defined(CONFIG_X86_64) || defined(CONFIG_IA64)
> +/*
> + * This code works only for 32 bit quota tools over 64 bit OS (x86_64, ia64)
> + * and is necessary due to alignment problems.
> + */

The #ifdef looks way too arch-specific. And isn't there a shared
compat.c module somewhere that this should go into?

/Mikael
