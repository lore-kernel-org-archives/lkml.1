Return-Path: <linux-kernel-owner+w=401wt.eu-S1755498AbZCKTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498AbZCKTVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 15:21:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZCKTVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 15:21:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36936 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754008AbZCKTVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 15:21:10 -0400
Message-ID: <49B80E9D.3@sandeen.net>
Date: Wed, 11 Mar 2009 14:18:53 -0500
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, tony.luck@intel.com,
       ralf@linux-mips.org, kyle@mcmartin.ca, schwidefsky@de.ibm.com
Subject: Re: [PATCH] generic compat_sys_ustat
References: <20081121084105.GA7155@lst.de> <20081128090909.GA28299@lst.de>
In-Reply-To: <20081128090909.GA28299@lst.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> Due to a different size of ino_t ustat needs a compat handler, but
> currently only x86 and mips provide one.  Add a generic compat_sys_ustat
> and switch all architectures over to it.  Instead of doing various
> user copy hacks compat_sys_ustat just reimplements sys_ustat as
> it's trivial.  This was suggested by Arnd Bergmann.
> 
> Found by Eric Sandeen when running xfstests/017 on ppc64, which causes
> stack smashing warnings on RHEL/Fedora due to the too large amount of
> data writen by the syscall.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks like this got lost?

-Eric

> 
> Index: linux-2.6/arch/x86/ia32/ia32entry.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/ia32/ia32entry.S	2008-11-28 14:09:01.000000000 +0530
> +++ linux-2.6/arch/x86/ia32/ia32entry.S	2008-11-28 14:09:16.000000000 +0530
> @@ -555,7 +555,7 @@ ia32_sys_call_table:
>  	.quad sys32_olduname
>  	.quad sys_umask		/* 60 */
>  	.quad sys_chroot
> -	.quad sys32_ustat
> +	.quad compat_sys_ustat
>  	.quad sys_dup2
>  	.quad sys_getppid
>  	.quad sys_getpgrp		/* 65 */

....
